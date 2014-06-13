module Alice

  module Handlers

    class ItemFinder

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        return unless thing = Alice::Item.from(command) || Alice::Beverage.from(command) || Actor.from(command)
        Alice::Handlers::Response.new(content: formatted_response(thing), kind: :reply)
      end

      def self.formatted_response(thing)
        if thing.respond_to?(:user) && thing.user
          message = [
            "The #{thing.name} belongs to #{thing.owner}",
            "#{thing.owner} has been its guardian for #{thing.owned_time}.",
            "#{thing.owner} holds the #{thing.name}.",
            "It is said that the #{thing.name} resides deep in the pockets of #{thing.owner}.",
            "Don't look at me, look at #{thing.owner}.",
            "Forged long ago in the fires of Mt. Doom, the #{thing.name} is now guarded by the fearsome #{thing.owner}."
          ].sample
        elsif thing.place
          message = "I would look #{Alice::Locator.new(thing).locate.to_sentence} of here."
        else
          message = "I have no idea where #{thing.name} is."
        end
      end

    end

  end

end