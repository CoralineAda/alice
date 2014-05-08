module Alice

  module Handlers

    class Beverage

      include PoroPlus

      attr_accessor :raw_command

      def self.minimum_indicators
        3
      end

      def process
        return unless self.respond_to? response_method
        Alice::Handlers::Response.new(send(response_method))
      end

      private

      def response_method
        self.method.to_sym || self.command.response_method.to_sym
      end

      def brew
        { content: Alice::Beverage.total_inventory, kind: :reply }
      end

      def drink
      end

      def spill
      end

      def list
        { content: Alice::Beverage.total_inventory, kind: :reply }
      end

    end

  end

end