module Alice

  module Handlers

    class ItemGiver

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        return unless command.present?
        grams = Alice::Parser::NgramFactory.new(command.gsub(/[^a-zA-Z0-9\_\ ]/, '')).omnigrams - [Alice.bot.bot.nick]
        return unless recipient = grams.map{|g| Alice::Util::Mediator.exists?(g.join(' ')) && g}.compact.flatten.last

        giver_user = Alice::User.like(sender)
        recipient_user = Alice::User.find_or_create(recipient)
        
        if item = Alice::Item.from(command)
          item = giver_user.items.include?(item) && item
        end

        if beverage = Alice::Beverage.from(command).last
          beverage = giver_user.beverages.include?(item) && item
        end

        if item
          giver_user.remove_from_inventory(item)
          recipient_user.add_to_inventory(item)
          Alice::Handlers::Response.new(content: "#{giver_user.proper_name} hands the #{item.name} over to #{recipient_user.proper_name}.", kind: :reply)
        elsif beverage
          giver_user.remove_from_inventory(beverage)
          recipient_user.add_to_inventory(beverage)
          Alice::Handlers::Response.new(content: "#{giver_user.proper_name} passes the #{beverage.name} over to #{recipient_user.proper_name}.", kind: :reply)
        else
          Alice::Handlers::Response.new(content: "I can't seem to find any #{item}.", kind: :reply)
        end
      end

    end

  end

end