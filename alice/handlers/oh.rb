module Alice

  module Handlers

    class Oh

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        if oh = Alice::Oh.random
          Alice::Response.new(content: oh.formatted, kind: :reply)
        end
      end

    end

  end

end