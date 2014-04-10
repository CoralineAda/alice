require 'cinch'

module Alice

  module Listeners

    class Item

      include Cinch::Plugin
      include Alice::Behavior::Listens
      include Alice::Behavior::TracksActivity

      match /^\!forge (.+)/,    method: :forge, use_prefix: false
      match /^\!steal (.+)/,    method: :steal, use_prefix: false
      match /^\!inventory/,     method: :inventory, use_prefix: false
      match /^\!stuff/,         method: :inventory, use_prefix: false
      match /^\!items/,         method: :inventory, use_prefix: false
      match /^\!destroy (.+)/,  method: :destroy, use_prefix: false
      match /^\!get (.+)/,      method: :get, use_prefix: false
      match /^\!grab (.+)/,     method: :get, use_prefix: false
      match /^\!pick up (.+)/,  method: :get, use_prefix: false
      match /^\!drop (.+)/,     method: :drop, use_prefix: false
      match /^\!discard (.+)/,  method: :drop, use_prefix: false
      match /^\!hide (.+)/,     method: :hide, use_prefix: false
      match /^\!examine (.+)/,  method: :inspect, use_prefix: false
      match /^\!inspect (.+)/,  method: :inspect, use_prefix: false
      match /^\!look (.+)$/,    method: :inspect, use_prefix: false
      match /^\!find (.+)/,     method: :find, use_prefix: false
      match /^\!play (.+)/,     method: :play, use_prefix: false
      match /^\!read (.+)/,     method: :read, use_prefix: false
      match /^\!talk (.+)/,     method: :talk, use_prefix: false

      # TODO copy this pattern!
      def find(channel_user, what)
        Alice::Util::Mediator.reply_to(channel_user, Alice::Handlers::ItemFinder.process(channel_user, what).content)
      end

      def inspect(channel_user, noun)
        if subject = Alice::User.from(noun.downcase).last  
          message ||= subject.description
        elsif subject = Alice::Item.from(noun.downcase).last || Alice::Beverage.from(noun.downcase).last || Alice::Actor.from(noun.downcase).last
          if Alice::Place.subject.contains?(noun)
            message ||= noun.description
          end
        elsif Alice::Place.current.description.include?(noun)
          message ||= Alice::Util::Randomizer.description(noun)
        end
        message ||= Alice::Util::Randomizer.not_here(noun)
        Alice::Util::Mediator.reply_to(channel_user, message)
      end

      def drop(channel_user, what)
        return unless item = Alice::Item.from(what).last
        return unless current_user = current_user_from(channel_user)
        return unless current_user = current_user_from(channel_user).items.include?(item)
        Alice::Util::Mediator.reply_to(channel_user, "It seems that the #{item.name} is cursed and cannot be dropped!") and return if item.is_cursed?
        Alice::Util::Mediator.reply_to(channel_user, Alice::Util::Randomizer.drop_message(item.name_with_article, channel_user.user.nick)) && item.drop
      end

      def talk(channel_user, who)
        return unless actor = Alice::Actor.from(who).last 
        return unless actor.is_present?
        return unless current_user = current_user_from(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, "#{actor.proper_name} #{actor.talk}")
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

      def get(channel_user, item)
        return unless noun = Alice::Item.from(item).last || Alice::Actor.from(item).last

        if Alice::Place.current.contains?(noun)          
          current_user_from(channel_user).add_to_inventory(noun)
          Alice::Util::Mediator.reply_to(channel_user, Alice::Util::Randomizer.pickup_message(noun.name, channel_user.user.nick))
        else
          Alice::Util::Mediator.reply_to(channel_user, "You cannot get #{item.name_with_article}!")
        end
      end

      def inventory(channel_user)
        if user = User.find_or_create(channel_user.user.nick)
          Alice::Util::Mediator.reply_to(channel_user, user.inventory)
        end
      end

      def destroy(channel_user, what)
        return unless item = Alice::Item.where(name: what.downcase).last
        unless m.channel.ops.map(&:nick).include?(channel_user.user.nick) || Alice::Util::Randomizer.one_chance_in(2)
          Alice::Util::Mediator.reply_to(channel_user, "You're not really up to the task of destroying the #{what} right now, #{channel_user.user.nick}.")
          return
        end
        Alice::Util::Mediator.emote_to(channel_user, "drops the #{what} into the fires of Mount Doom! That should do it.")
        item.destroy
      end

      def hide(channel_user, what)
        return unless current_user = current_user_from(channel_user)
        return unless item = Alice::Item.from(what).select{|t| t.user == current_user}.first
        return unless current_user = current_user_from(channel_user).items.include?(item)
        Alice::Util::Mediator.reply_to(channel_user, item.hide(channel_user.user.nick))
      end

      def forge(channel_user, what)
        if item = Alice::Item.exists?(what)
          Alice::Util::Mediator.reply_to(channel_user, "Everyone knows that a #{what} is a singleton.")
          return
        end
        user = Alice::User.find_or_create(channel_user.user.nick)

        if user.can_forge?
          Alice::Item.forge(name: what.downcase, user: user, creator_id: user.id)
          Alice::Util::Mediator.emote_to(channel_user, "forges a #{what} #{Alice::Util::Randomizer.forge} for #{channel_user.user.nick}.")
        else
          Alice::Util::Mediator.emote_to(channel_user, "thinks that #{channel_user.user.nick} has enough stuff already.")
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
        message = thief.try_stealing(what)
        Alice::Util::Mediator.emote_to(channel_user, message)
      end

    end

  end

end