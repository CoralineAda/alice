module Alice

  module Handlers

    class ItemGiver

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        return unless command.present?
        grams = Alice::Parser::NgramFactory.new(command.gsub(/[^a-zA-Z0-9\_\ ]/, '')).omnigrams - [Alice.bot.bot.nick]
        return unless recipient = grams.map{|g| Alice::Mediator.exists?(g.join(' ')) && g}.compact.flatten.last

        giver_user = Alice::User.like(sender)
        recipient_user = Alice::User.find_or_create(recipient)
        item = Alice::Item.from(command).last
        beverage = Alice::Beverage.from(command).last

        if item
          giver_user.remove_from_inventory(item)
          recipient_user.add_to_inventory(item)
          Alice::Util::Mediator.reply_to(channel_user, "#{giver_user.proper_name} hands the #{item.name} over to #{recipient_user.proper_name}.")
        elsif beverage
          giver_user.remove_from_cooler(item)
          recipient_user.add_to_cooler(item)
          Alice::Util::Mediator.reply_to(channel_user, "#{giver_user.proper_name} passes the #{item.name} to #{recipient_user.proper_name}.")
        end
      end

    end

  end

end