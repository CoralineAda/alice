require 'pry'

module Behavior

  module Steals

    def recently_stole?
      self.last_theft ||= DateTime.now - 1.day
      self.last_theft >= DateTime.now - 13.minutes
    end

    def steal(what, response_type=:emote)
      return unless what
      if recently_stole? && response_type == :emote
        return "thinks that #{proper_name} shouldn't press #{self.pronoun_possessive} luck on the thievery front."
      end

      item = what if what.respond_to?(:name)
      item ||= Item.from(name: what.downcase).last || Beverage.from(name: what.downcase).last
      return "eyes #{proper_name} curiously." unless item
      return "#{Util::Randomizer.laugh} as #{proper_name} tries to steal #{self.pronoun_possessive} own #{item.name}!" if item.owner == self
      return "apologizes, but #{item.owner_name} locked that up tight before going to sleep!" unless item.owner.awake?

      if Util::Randomizer.one_chance_in(5)
        update_thefts
        if item.point_value > 1
          if response_type == :emote
            message = "stares in surprise as #{proper_name} steals the #{item.name}, worth #{item.point_value} Internet Points™, from #{item.owner_name}!"
          else
            message = "I just stole the #{item.name} from #{item.owner_name}! And it's worth #{item.point_value} Internet Points™!"
          end
        else
          if response_type == :emote
            message = "watches in wonder as #{proper_name} snatches the #{item.name} from #{item.owner_name}'s pocket!"
          else
            message = "Hey, #{item.owner_name}, I just stole your #{item.name}..."
          end
        end
        item.remove
        item.reset_theft_attempts
        item.change_owner(self)
        self.score_points if self.respond_to?(:score_points)
      else
        update_thefts
        if response_type == :emote
          message = "sees #{proper_name} try and fail to take the #{item.name} from #{item.owner_name}."
        else
          message = "Well, I just tried and failed to take the #{item.name} from #{item.owner_name}."
        end
        item.increment_theft_attempts
        self.penalize if self.respond_to?(:penalize)
      end
      message
    end

    def update_thefts
      self.update_attributes(last_theft: DateTime.now)
    end

  end

end
