module Alice

  module Handlers

    class Bio

      def self.minimum_indicators
        1
      end

      def self.process(sender, command)
        if subject = Alice::User.from(command)
          if bio = subject.formatted_bio
            Alice::Handlers::Response.new(content: bio, kind: :reply)
          else
            Alice::Handlers::Response.new(content: Alice::Util::Randomizer.dunno_response(subject, kind: :reply))
          end
        else
          Alice::Handlers::Factoid.process(sender, command)
        end
      end

    end

  end

end