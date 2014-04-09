module Alice

  module Handlers

    class Inventory

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        Alice::Response.new(content: Alice::User.find_or_create(sender).inventory, kind: :reply)
      end

    end

  end

end