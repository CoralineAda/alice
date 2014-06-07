module Alice

  module Handlers

    class Factoid

      def self.minimum_indicators
        3
      end

      def self.process(sender, command)
        if subject = User.from(command)
          if factoid = subject.factoids.sample
            Alice::Handlers::Response.new(content: factoid.formatted, kind: :reply)
          end
        elsif command =~ /about (.+)$/
          subject = command.split('about')[-1].strip
          if response = Alice::Factoid.about(subject)
            Alice::Handlers::Response.new(content: response.formatted, kind: :reply)
          else
            Alice::Handlers::Response.new(content: Alice::Util::Randomizer.negative_response, kind: :reply)
          end
        else
          Alice::Handlers::Response.new(content: random.formatted, kind: :reply)
        end
      end

      def self.random
        Alice::Factoid.random
      end

    end

  end

end