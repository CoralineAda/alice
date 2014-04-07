module Alice

  module Handlers

    class Bio

      def self.minimum_indicators
        1
      end

      def self.process(sender, command)
        if subject = Alice::User.from(command).sample
          if bio = subject.formatted_bio
            Alice::Response.new(content: bio, kind: :reply)
          else
            Alice::Response.new(content: "I don't know much about #{subject.primary_nick} yet.", kind: :reply)
          end
        else
          Alice::Response.new(content: negative_response, kind: :reply)
        end
      end

      def self.negative_response
        [
          "I would tell you if I could.",
          "I really can't talk about that.",
          "I wish I knew more about that.",
          "All I know is that the Dude abides.",
          "We don't talk about that here.",
          "No.",
          "I will not.",
          "I'm an enigma, remember?",
          "#nopenopenope"
        ].sample
      end

    end

  end

end