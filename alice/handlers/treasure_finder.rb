module Alice

  module Handlers

    class ItemFinder

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        item = Alice::Item.hidden.like('bow and arrow').first if command.include?('bow')
        item ||= Alice::Item.from(command).first
        if item
          Alice::Response.new(content: formatted_response(item), kind: :reply)
        end
      end

      def self.formatted_response(item)
        if item.user
          [
            "The #{item.name} belongs to #{item.owner}",
            "#{item.owner} has been its guardian for #{item.elapsed_time}.",
            "#{item.owner} holds the #{item.name}.",
            "It is said that the #{item.name} resides deep in the pockets of #{item.owner}.",
            "Don't look at me, look at #{item.owner}.",
            "Forged long ago in the fires of Mt. Doom, the #{item.name} is now guarded by the fearsome #{item.owner}."
          ].sample
        elsif item.place
          [
            "The #{item.name} may be found in #{item.place.description}.",
            "The #{item.name} may be discovered in #{item.place.description}.",
            "The #{item.name} is located in #{item.place.description}.",
            "The #{item.name} is hidden away in #{item.place.description}.",
            "The #{item.name}'s location is not known to me."
          ].sample
        end
      end

    end

  end

end