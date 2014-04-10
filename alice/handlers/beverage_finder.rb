module Alice

  module Handlers

    class BeverageFinder

      def self.minimum_indicators
        3
      end

      def self.process(sender, command)
        Alice::Handlers::Response.new(content: Alice::Beverage.total_inventory, kind: :reply)
      end

    end

  end

end