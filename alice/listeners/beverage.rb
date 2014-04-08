require 'cinch'

module Alice

  module Listeners

    class Beverage

      include Cinch::Plugin

      match /^\!spill (.+)/,  method: :spill, use_prefix: false
      match /^\!pour (.+)/,   method: :spill, use_prefix: false
      match /^\!brew (.+)/,   method: :brew, use_prefix: false
      match /^\!(drink|quaff|sip|swallow|gulp) (.+)/,   method: :drink, use_prefix: false

      def spill(m, what)
        return unless beverage = Alice::beverage.from(what).last
        return unless user = User.find_or_create(m.user.nick) 
        return unless user.beverages.include?(beverage)
        m.reply(beverage.drop_message(m.user.nick)) && beverage.destroy
      end

      def brew(m, what)
        unless m.channel.ops.map(&:nick).include?(m.user.nick) || rand(5) < 3
          m.reply("Your attempt at brewing failed miserably.")
          return
        end
        if beverage = Alice::beverage.where(name: what.downcase).last
          m.reply("Everyone knows that there can only be one #{what}.")
          return
        end
        user = Alice::User.find_or_create(m.user.nick)
        Alice::beverage.create(name: what.downcase, user: user)
        m.action_reply("looks on in wonder as #{m.user.nick} brews an impressive #{what}.")
      end

      def drink(m, what)
        return unless user = User.find_or_create(m.user.nick) 
        unless beverage = Alice::beverage.from(what).last
          m.reply("There is no such drink as a #{beverage.name}. Maybe you should brew one?"
          return
        end
        unless user.beverages.include?(beverage)
          m.reply("You don't even have the #{beverage.name}!"
          return
        end
        beverage.consume
      end

    end

  end

end