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
      match /^\!destroy (.+)/,  method: :destroy, use_prefix: false
      match /^\!get (.+)/,      method: :get, use_prefix: false
      match /^\!pick up (.+)/,  method: :get, use_prefix: false
      match /^\!drop (.+)/,     method: :drop, use_prefix: false
      match /^\!discard (.+)/,  method: :drop, use_prefix: false
      match /^\!hide (.+)/,     method: :hide, use_prefix: false
      match /^\!examine (.+)/,  method: :inspect, use_prefix: false
      match /^\!inspect (.+)/,  method: :inspect, use_prefix: false
      match /^\!find (.+)/,     method: :find, use_prefix: false

      # TODO copy this pattern!
      def find(channel_user, what)
        Alice::Util::Mediator.reply_to(channel_user, Alice::Handlers::ItemFinder.process(channel_user, what).content)
      end

      def inspect(channel_user, what)
        return unless noun = Alice::Item.from(what).last || Alice::Actor.from(what).last
        if current_user_from(channel_user).items.include?(noun) || Alice::Place.current.contains?(noun)
          Alice::Util::Mediator.emote_to(channel_user, item.description)
        else
          Alice::Util::Mediator.reply_to(channel_user, "#{item.proper_name} is not visible to you.")
        end
      end

      def drop(channel_user, what)
        return unless item = Alice::Item.from(what).last
        return unless current_user
        return unless user.items.include?(item)
        Alice::Util::Mediator.reply_to(channel_user, "It seems that the #{item.name} is cursed and cannot be dropped!") and return if item.cursed?
        Alice::Util::Mediator.reply_to(channel_user, item.drop_message(channel_user.user.nick)) && item.drop
      end

      def get(channel_user, item)
        return unless noun = Alice::Item.from(what).last || Alice::Actor.from(what).last
        if Alice::Place.current.contains?(noun)
          user_from(channel_user).add_to_inventory(item)
          Alice::Util::Mediator.reply_to(channel_user, Alice::Randomizer.pickup_message(item.name, channel_user.user.nick))
        else
          Alice::Util::Mediator.reply_to(channel_user, "You cannot get the #{item}!")
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
        return unless current_user
        return unless item = Alice::Item.from(what).select{|t| t.user == user}.first
        return unless user.items.include?(item)
        Alice::Util::Mediator.reply_to(channel_user, item.hide(channel_user.user.nick))
      end

      def forge(channel_user, what)
        if item = Alice::Item.where(name: what.downcase).last
          Alice::Util::Mediator.reply_to(channel_user, "Everyone knows that that's a singleton.")
          return
        end
        user = Alice::User.find_or_create(channel_user.user.nick)

        if user.can_forge?
          Alice::Item.create(name: what.downcase, user: user)
          Alice::Util::Mediator.emote_to(channel_user, "forges a #{what} #{Alice::Util::Randomizer.forge} for #{channel_user.user.nick}.")
        else
          Alice::Util::Mediator.emote_to(channel_user, "thinks that #{channel_user.user.nick} has enough stuff already.")
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