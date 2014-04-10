require 'cinch'

module Alice

  module Listeners

    class Item

      include Cinch::Plugin
      include Alice::Behavior::Listens
      include Alice::Behavior::TracksActivity

      match /^\!forge (.+)/i,    method: :forge, use_prefix: false
      match /^\!steal (.+)/i,    method: :steal, use_prefix: false
      match /^\!inventory/i,     method: :inventory, use_prefix: false
      match /^\!stuff/i,         method: :inventory, use_prefix: false
      match /^\!items/i,         method: :inventory, use_prefix: false
      match /^\!destroy (.+)/i,  method: :destroy, use_prefix: false
      match /^\!get (.+)/i,      method: :get, use_prefix: false
      match /^\!grab (.+)/i,     method: :get, use_prefix: false
      match /^\!pick up (.+)/i,  method: :get, use_prefix: false
      match /^\!drop (.+)/i,     method: :drop, use_prefix: false
      match /^\!discard (.+)/i,  method: :drop, use_prefix: false
      match /^\!hide (.+)/i,     method: :hide, use_prefix: false
      match /^\!examine (.+)/i,  method: :inspect, use_prefix: false
      match /^\!inspect (.+)/i,  method: :inspect, use_prefix: false
      match /^\!look (.+)$/i,    method: :inspect, use_prefix: false
      match /^\!find (.+)/i,     method: :find, use_prefix: false
      match /^\!play (.+)/i,     method: :play, use_prefix: false
      match /^\!read (.+)/i,     method: :read, use_prefix: false
      match /^\!talk (.+)/i,     method: :talk, use_prefix: false

      def destroy(channel_user, what)
        return unless item = Alice::Item.from(what).last
        unless Alice::Util::Mediator.op?(channel_user) || Alice::Util::Randomizer.one_chance_in(2)
          Alice::Util::Mediator.reply_to(channel_user, "You're not really up to the task of destroying the #{what} right now, #{channel_user.user.nick}.")
          return
        end
        Alice::Util::Mediator.emote_to(channel_user, "drops the #{what} into the fires of Mount Doom! That should do it.")
        item.destroy
      end

      def drop(channel_user, what)
        return unless item = Alice::Item.from(what).last
        return unless current_user = current_user_from(channel_user)
        return unless current_user = current_user_from(channel_user).items.include?(item)
        if item.is_cursed?
          Alice::Util::Mediator.reply_to(channel_user, "It seems that the #{item.name} is cursed and cannot be dropped!")
        else
          Alice::Util::Mediator.reply_to(channel_user, Alice::Util::Randomizer.drop_message(item.name_with_article, channel_user.user.nick)) && item.drop
        end
      end

      # TODO copy this pattern!
      def find(channel_user, what)
        Alice::Util::Mediator.reply_to(channel_user, Alice::Handlers::ItemFinder.process(channel_user, what).content)
      end

      def forge(channel_user, what)
        if item = Alice::Item.already_exists?(what)
          Alice::Util::Mediator.reply_to(channel_user, "Everyone knows that a #{what} is a singleton.")
          return
        end
        
        current_user = current_user_from(channel_user)

        if current_user.can_forge?
          Alice::Item.forge(name: what.downcase, user: current_user, creator_id: current_user.id)
          Alice::Util::Mediator.emote_to(channel_user, "forges a #{what} #{Alice::Util::Randomizer.forge} for #{channel_user.user.nick}.")
        else
          Alice::Util::Mediator.emote_to(channel_user, "thinks that #{channel_user.user.nick} has enough stuff already.")
        end
      end

      def get(channel_user, item)
        noun = Alice::Item.from(item).last || Alice::Actor.from(item).last
        if noun && Alice::Place.current.contains?(noun)          
          current_user_from(channel_user).add_to_inventory(noun)
          Alice::Util::Mediator.reply_to(channel_user, Alice::Util::Randomizer.pickup_message(noun.name, channel_user.user.nick))
        else
          Alice::Util::Mediator.reply_to(channel_user, "You cannot get the #{item}!")
        end
      end

      def hide(channel_user, what)
        current_user = current_user_from(channel_user)
        return unless item = Alice::Item.from(what).select{|t| t.user == current_user}.first
        return unless current_user = current_user_from(channel_user).items.include?(item)
        if item.is_cursed?
          Alice::Util::Mediator.reply_to(channel_user, "It seems that the #{item.name} is cursed and cannot be hidden!")
        else
          Alice::Util::Mediator.reply_to(channel_user, item.hide(channel_user.user.nick))
        end
      end

      def inspect(channel_user, noun)
        current_user = current_user_from(channel_user)
        subject = Alice::User.from(noun.downcase).last
        subject ||= Alice::Actor.from(noun.downcase).last
        subject ||= Alice::Item.from(noun).last
        subject ||= Alice::Beverage.from(noun).last
        
        if subject.is_present? || current_user.items.include?(subject) || current_user.beverages.include?(subject)
          message = subject.describe
        else
          message = Alice::Util::Randomizer.not_here(noun)  
        end

        Alice::Util::Mediator.reply_to(channel_user, message)
      end

      def inventory(channel_user)
        user = current_user_from(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, user.inventory)
      end

      def play(channel_user, game)
        item = Alice::Item.from(game).last
        return unless current_user = current_user_from(channel_user)
        if item && current_user.items.include?(item)
          Alice::Util::Mediator.reply_to(channel_user, "#{item.play}.")
        else
          Alice::Util::Mediator.reply_to(channel_user, "You don't have #{game.name_with_article}.")
        end
      end

      def read(channel_user, what)
        item = Alice::Item.where(name: /#{what}/i).last
        if item && current_user_from(channel_user).items.include?(item)
          Alice::Util::Mediator.reply_to(channel_user, "#{item.read}.")
        else
          Alice::Util::Mediator.reply_to(channel_user, "You don't have a #{what}.")
        end
      end

      def steal(channel_user, what)
        thief = Alice::User.find_or_create(channel_user.user.nick)
        message = thief.steal(what)
        Alice::Util::Mediator.emote_to(channel_user, message)
      end

      def talk(channel_user, who)
        return unless actor = Alice::Actor.from(who).last 
        return unless actor.is_present?
        return unless current_user = current_user_from(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, "#{actor.proper_name} #{actor.talk}")
      end

    end

  end

end