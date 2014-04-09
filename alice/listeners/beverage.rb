require 'cinch'

module Alice

  module Listeners

    class Beverage

      include Cinch::Plugin

      match /^\!spill (.+)/,    method: :spill, use_prefix: false
      match /^\!pour (.+)/,     method: :spill, use_prefix: false
      match /^\!brew (.+)/,     method: :brew, use_prefix: false
      match /^\!drink (.+)/,    method: :drink, use_prefix: false
      match /^\!quaff (.+)/,    method: :drink, use_prefix: false
      match /^\!sip (.+)/,      method: :drink, use_prefix: false
      match /^\!swallow (.+)/,  method: :drink, use_prefix: false
      match /^\!gulp (.+)/,     method: :drink, use_prefix: false
      match /^\!down (.+)/,     method: :drink, use_prefix: false
      match /^\!chug (.+)/,     method: :drink, use_prefix: false
      match /^\!drinks/,        method: :list_drinks, use_prefix: false
      match /^\!fridge/,        method: :list_drinks, use_prefix: false

      def drink(m, what)
        beverage = ensure_beverage(m, what)
        beverage && m.reply(beverage.drink)
      end

      def spill(m, what)
        beverage = ensure_beverage(m, what)
        beverage && m.reply(beverage.spill)
      end

      def list_drinks(m)
        m.reply(Alice::Beverage.list)
      end

      def ensure_beverage(m, what)
        return unless user = User.find_or_create(m.user.nick) 
        unless beverage = Alice::Beverage.from(what).last
          m.reply("There is no such drink as a #{what}. Maybe you should brew one?")
          return
        end
        unless user.beverages.include?(beverage)
          m.reply("You don't even have the #{beverage.name}!")
          return
        end
        beverage
      end

      def brew(m, what)
        unless Alice::Mediator.op?(m) || rand(5) < 3
          m.reply("Your attempt at brewing failed miserably.")
          return
        end
        if beverage = Alice::Beverage.where(name: what.downcase).last
          m.reply("Everyone knows that there can only be one #{what}.")
          return
        end
        user = Alice::User.find_or_create(m.user.nick)
        beverage = Alice::Beverage.create(name: what.downcase, user: user)
        m.action_reply("#{Alice::Randomizer.brew_message}")
      end

    end

  end

end