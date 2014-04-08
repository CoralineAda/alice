module Alice

  module Handlers

    class TreasureGiver

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        return unless command.present?
        grams = Alice::Parser::NgramFactory.new(command.gsub(/[^a-zA-Z0-9\_\ ]/, '')).omnigrams - [Alice.bot.bot.nick]
        nick = grams.map{|g| Alice.bot.exists?(g.join(' ')) && g}.compact.flatten.last
        return unless nick
        user = Alice::User.find_or_create(nick)
        treasure = Alice::Treasure.from(command).last
        beverage = Alice::Beverage.from(command).last
        if treasure
          treasure.to(nick)
          Alice::Response.new(content: treasure.message, kind: :reply)
        elsif beverage
          beverage.pass_to(nick)
          Alice::Response.new(content: beverage.message, kind: :reply)
        end
      end

    end

  end

end