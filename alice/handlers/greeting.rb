module Alice

  module Handlers

    class Greeting

      def self.process(sender, command)
        Alice::Handlers::Response.new(content: Alice::Util::Randomizer.greeting(sender), kind: :action)
      end

    end

  end

end