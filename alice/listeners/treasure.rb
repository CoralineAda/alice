require 'cinch'

module Alice

  module Listeners

    class Treasure

      include Cinch::Plugin

      match /^\!forge (.+)/,    method: :forge, use_prefix: false
      match /^\!steal (.+)/,    method: :steal, use_prefix: false
      match /^\!inventory/,     method: :inventory, use_prefix: false
      match /^\!destroy (.+)/,  method: :destroy, use_prefix: false
      match /^\!get (.+)/,      method: :get, use_prefix: false
      match /^\!pick up (.+)/,  method: :get, use_prefix: false
      match /^\!drop (.+)/,     method: :drop, use_prefix: false
      match /^\!discard (.+)/,  method: :drop, use_prefix: false
      match /^\!hide (.+)/,     method: :hide, use_prefix: false
      match /^\!examine (.+)/,  method: :inspect, use_prefix: false
      match /^\!inspect (.+)/,  method: :inspect, use_prefix: false
      match /^\!find (.+)/,     method: :find, use_prefix: false

      def find(m, what)
        m.reply(Alice::Handlers::TreasureFinder.process(m, what).content)
      end

      def inspect(m, what)
        return unless treasure = Alice::Treasure.from(what).last
        if user.treasures.include?(treasure) || Alice::Place.last.contains?(what)
          m.action_reply(treasure.description)
        else
          m.reply("The #{treasure.name} is not visible to you").gsub("the the", "the").gsub("the ye", "ye")
        end
      end

      def drop(m, what)
        return unless treasure = Alice::Treasure.from(what).last
        return unless user = User.find_or_create(m.user.nick) 
        return unless user.treasures.include?(treasure)
        m.reply("It seems that the #{treasure.name} is cursed and cannot be dropped!") and return if treasure.cursed?
        m.reply(treasure.drop_message(m.user.nick)) && treasure.drop
      end

      def get(m, item)
        treasure = Alice::Treasure.like(item).first
        if Alice::Place.last.contains?(item)
          m.reply(treasure.pickup_message(m.user.nick)) && treasure.to(m.user.nick)
        else
          message = "You cannot get the #{item}!"
          message = message.gsub("the ye", "ye")
          message = message.gsub('the the', 'the')
          m.reply(message)
        end
      end

      def inventory(m)
        if user = User.find_or_create(m.user.nick)
          m.reply(user.inventory)
        end
      end

      def destroy(m, what)
        return unless treasure = Alice::Treasure.where(name: what.downcase).last
        unless m.channel.ops.map(&:nick).include?(m.user.nick) || rand(5) == 1
          m.reply("It seems that only a god or goddess may destroy the #{what}, #{m.user.nick}.")
          return
        end
        m.action_reply("drops the #{what} into the fires of Mount Doom whence it was wrought!")
        treasure.destroy
      end

      def hide(m, what)
        return unless user = User.find_or_create(m.user.nick) 
        return unless treasure = Alice::Treasure.from(what).select{|t| t.user == user}.first
        return unless user.treasures.include?(treasure)
        m.reply(treasure.hide(m.user.nick))
      end

      def forge(m, what)
        unless m.channel.ops.map(&:nick).include?(m.user.nick) || rand(5) == 1
          m.reply("You're not the boss of me, #{m.user.nick}.")
          return
        end
        if treasure = Alice::Treasure.where(name: what.downcase).last
          m.reply("Everyone knows that that's a singleton.")
          return
        end
        user = Alice::User.find_or_create(m.user.nick)
        Alice::Treasure.create(name: what.downcase, user: user)
        m.action_reply("forges a #{what} in the fires of Mount Doom for #{m.user.nick}.")
      end

      def steal(m, what)
        thief = Alice::User.find_or_create(m.user.nick)
        message = thief.try_stealing(what)
        m.action_reply(message)
      end

    end

  end

end