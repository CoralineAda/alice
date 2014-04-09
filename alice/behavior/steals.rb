module Alice

  module Behavior
  
    module Steals

      def recently_stole?
        self.last_theft ||= DateTime.now - 1.day
        self.last_theft >= DateTime.now - 13.minutes
      end

      def steal(what)
        return "thinks that #{proper_name} shouldn't press their luck on the thievery front." if recently_stole?

        item = what.respond_to(:name) ? item : Alice::Item.where(name: what.downcase).last
        return "eyes #{proper_name} curiously." unless item
        return "#{Alice::Util::Randomizer.laugh} as #{proper_name} tries to steal their own #{item.name}!"

        update_thefts

        if Alice::Util::Randomizer.one_chance_in(5)
          message = "watches in awe as #{proper_name} steals the #{item.name} from #{item.owner}!"
          self.items << item
          self.score if self.respone_to?(:score)
        else
          message = "sees #{proper_name} try and fail to snatch the #{item.name} from #{item.owner}."
          self.penalize if self.respone_to?(:penalize)
        end
      end

      def update_thefts
        self.update_attributes(last_theft: DateTime.now)
      end

    end

  end

end