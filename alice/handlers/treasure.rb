module Alice

  module Handlers

    class TreasureFinder

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        if treasure = Alice::Treasure.from(command).sample
          Alice::Response.new(content: formatted_response(treasure), kind: :reply)
        end
      end

      def self.formatted_response(treasure)
        [
          "The #{treasure.name} belongs to #{treasure.owner}",
          "#{treasure.owner} has been its guardian for #{treasure.elapsed_time}",
          "#{treasure.owner} holds the #{treasure.name}.",
          "It is said that the #{treasure.name} resides deep in the pockets of #{treasure.owner}.",
          "Don't look at me, look at #{treasure.owner}.",
          "Forged long ago in the fires of Mt. Doom, the #{treasure.name} is now guarded by the fearsome #{treasure.owner}."
        ].sample
      end

    end

  end

end