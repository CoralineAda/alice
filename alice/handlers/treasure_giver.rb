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
        user = Alice::User.find_or_create(nick)
        treasure = Alice::Treasure.from(command).last
        return unless nick
        return unless treasure
        treasure.to(nick)
        Alice::Response.new(content: treasure.message, kind: :reply)
      end

    end

  end

end