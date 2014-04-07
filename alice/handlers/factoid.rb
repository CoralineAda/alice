module Alice

  module Handlers

    class Factoid

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        if subject = command.split(/[^a-zA-Z0-9\_]/).map{|name| Alice::User.like(name) }.compact.sample
          if factoid = subject.factoids.sample
            Alice::Response.new(content: factoid.formatted, kind: :reply)
          end
        else
          Alice::Response.new(content: random.formatted, kind: :reply)
        end
      end

      def self.random
        all.sample
      end

    end

  end

end