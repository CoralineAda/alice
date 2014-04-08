module Alice

  module Handlers

    class TreasureGiver

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        return unless command.present?
        grams = Alice::Parser::NgramFactory.new(string.gsub(/[^a-zA-Z0-9\_\ ]/, '')).omnigrams
        nick = grams.map{|g| Alice.bot.exists?(g) && g}.compact.last
        treasure = Alice::Treasure.from(command)
        return unless nick
        return unless treasure
        user = Alice::User.find_or_create(nick)
        treasure.to(user)
        Alice::Response.new(content: treasure.message, kind: :reply)
      end

    end

  end

end