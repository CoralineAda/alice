module Alice

  module Handlers

    class ItemLister

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        Alice::Handlers::Response.new(content: Alice::Item.total_inventory, kind: :reply)
      end

    end

  end

end