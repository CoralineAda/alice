require 'cinch'

module Alice

  module Listeners

    class Beverage

      include Alice::Behavior::Listens
      include Alice::Behavior::TracksActivity
      include Cinch::Plugin

      match /^\!spill (.+)/i,    method: :spill,       use_prefix: false
      match /^\!pour (.+)/i,     method: :spill,       use_prefix: false
      match /^\!brew (.+)/i,     method: :brew,        use_prefix: false
      match /^\!drink (.+)/i,    method: :drink,       use_prefix: false
      match /^\!quaff (.+)/i,    method: :drink,       use_prefix: false
      match /^\!sip (.+)/i,      method: :drink,       use_prefix: false
      match /^\!swallow (.+)/i,  method: :drink,       use_prefix: false
      match /^\!gulp (.+)/i,     method: :drink,       use_prefix: false
      match /^\!down (.+)/i,     method: :drink,       use_prefix: false
      match /^\!chug (.+)/i,     method: :drink,       use_prefix: false
      match /^\!drinks/i,        method: :list_my_drinks, use_prefix: false
      match /^\!fridge/i,        method: :list_drinks, use_prefix: false
      match /^\!cooler/i,        method: :list_drinks, use_prefix: false

      def brew(channel_user, what)
        if Alice::Util::Mediator.non_op?(channel_user) && Alice::Util::Randomizer.one_chance_in(5)
          Alice::Util::Mediator.reply_to(channel_user, "Your attempt at brewing failed miserably.")
          return
        end
        if Alice::Beverage.already_exists?(what)
          Alice::Util::Mediator.reply_to(channel_user, "Everyone knows that there can only be one #{what}.")
          return
        else
          user = current_user_from(channel_user)

          if user.can_brew?
            beverage = Alice::Beverage.create(name: what.downcase, user: user)
            if observer == Alice::User.bot
              Alice::Util::Mediator.emote_to(channel_user, "#{observer.observe_brewing(beverage.name, channel_user.user.nick)}")
            else
              Alice::Util::Mediator.reply_to(channel_user, "#{observer.proper_name} #{actor.observe_brewing(beverage.name, channel_user.user.nick)}")
            end
          else
              Alice::Util::Mediator.reply_to(channel_user, "#{user.proper_name} has enough beverages.")
          end
        end
        
      end

      def drink(channel_user, what)
        if beverage = ensure_beverage(channel_user, what)
          Alice::Util::Mediator.reply_to(channel_user, beverage.drink)
        end
      end

      def spill(channel_user, what)
        if beverage = ensure_beverage(channel_user, what)
          Alice::Util::Mediator.reply_to(channel_user, beverage.spill)
        end
      end

      def list_my_drinks(channel_user)
        user = current_user_from(channel_user)
        if user.beverages.present?
          Alice::Util::Mediator.reply_to(channel_user, user.inventory_of_beverages)
        else
          Alice::Util::Mediator.reply_to(channel_user, "Your cooler is empty.")
        end
      end

      def list_drinks(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, Alice::Beverage.total_inventory)
      end

      def ensure_beverage(channel_user, what)
        unless beverage = Alice::Beverage.from(what).last
          Alice::Util::Mediator.reply_to(channel_user, "There is no such drink as a #{what}. Maybe you should brew one?")
          return
        end
        unless current_user_from(channel_user).beverages.include?(beverage)
          Alice::Util::Mediator.reply_to(channel_user, "You don't even have the #{beverage.name}!")
          return
        end
        beverage
      end

    end

  end

end