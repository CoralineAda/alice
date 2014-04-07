require 'cinch'

module Alice

  module Listeners

    class Treasure

      include Cinch::Plugin

      match /^\!(.+) (.+)/, method: :treasure, use_prefix: false
      match /^\!forge (.+)/, method: :forge, use_prefix: false
      match /^\!steal (.+)/, method: :steal, use_prefix: false
      match /^\!drop (.+)/, method: :drop, use_prefix: false
      match /^\!discard (.+)/, method: :drop, use_prefix: false
      match /^\!inventory/, method: :inventory, use_prefix: false
      match /^\!destroy (.+)/, method: :destroy, use_prefix: false
      match /^[ha|bwa]/, method: :laugh, use_prefix: false

      def laugh(m)
        return unless rand(5) == 1
        name = m.user.nick
        sound = [
          "laughs along with #{name}.",
          "grins at #{name}.",
          "chuckles.",
          "cackles!",
          "smiles."
        ].sample
        m.action_reply(sound)
      end

      def inventory(m)
        if user = User.find_or_create(m.user.nick)
          m.reply(user.inventory)
        end
      end

      def drop(m, what)
        return unless treasure = Alice::Treasure.where(name: what.downcase).last
        m.reply("It seems that the #{treasure.name} is cursed and cannot be dropped!") and return if rand(5) == 1
        message = treasure.transfer_from(m.user.nick).to(Alice::User.random.primary_nick).message
        m.reply(message)
      end

      def destroy(m, what)
        return unless treasure = Alice::Treasure.where(name: what.downcase).last
        unless m.channel.ops.map(&:nick).include?(m.user.nick)
          m.reply("Only a god or goddess may destroy the #{what}, #{m.user.nick}.")
          return
        end
        m.action_reply("drops the #{what} into the fires of Mount Doom whence it was wrought!")
        treasure.destroy
      end

      def forge(m, what)
        unless m.channel.ops.map(&:nick).include?(m.user.nick)
          m.reply("You're not the boss of me, #{m.user.nick}.")
          return
        end
        if treasure = Alice::Treasure.where(name: what.downcase).last
          m.reply("Everyone knows that that's a singleton.")
          return
        end
        user = Alice::User.find_or_create(m.user.nick)
        Alice::Treasure.create(name: what.downcase, user: user)
        m.action_reply("forges a #{what} in the fires of Mount Doom.")
      end

      def steal(m, what)
        return if what == 'forge'
        thief = Alice::User.find_or_create(m.user.nick)
        message = thief.try_stealing(what)
        m.action_reply(message)
      end

      def treasure(m, what, who)
        return if what == 'forge'
        return unless treasure = Alice::Treasure.where(name: what.downcase).last
        message = treasure.transfer_from(m.user.nick).to(who).message
        m.reply(message)
      end

    end

  end

end