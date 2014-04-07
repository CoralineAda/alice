module Alice

  module Handlers

    class TreasureLister

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        Alice::Response.new(content: Alice::Treasure.list, kind: :reply)
      end

    end

  end

end