module Alice

  module Handlers

    class BeverageFinder

      def self.minimum_indicators
        3
      end

      def self.process(sender, command)
        Alice::Response.new(content: Alice::Beverage.list, kind: :reply)
      end

    end

  end

end