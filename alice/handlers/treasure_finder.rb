module Alice

  module Handlers

    class TreasureFinder

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        treasure = Alice::Treasure.hidden.like('bow and arrow').first if command.include?('bow')
        treasure ||= Alice::Treasure.from(command).first
        if treasure
          Alice::Response.new(content: formatted_response(treasure), kind: :reply)
        end
      end

      def self.formatted_response(treasure)
        if treasure.user
          [
            "The #{treasure.name} belongs to #{treasure.owner}",
            "#{treasure.owner} has been its guardian for #{treasure.elapsed_time}.",
            "#{treasure.owner} holds the #{treasure.name}.",
            "It is said that the #{treasure.name} resides deep in the pockets of #{treasure.owner}.",
            "Don't look at me, look at #{treasure.owner}.",
            "Forged long ago in the fires of Mt. Doom, the #{treasure.name} is now guarded by the fearsome #{treasure.owner}."
          ].sample
        elsif treasure.place
          [
            "The #{treasure.name} may be found in #{treasure.place.description}.",
            "The #{treasure.name} may be discovered in #{treasure.place.description}.",
            "The #{treasure.name} is located in #{treasure.place.description}.",
            "The #{treasure.name} is hidden away in #{treasure.place.description}.",
            "The #{treasure.name}'s location is not known to me."
          ].sample
        end
      end

    end

  end

end