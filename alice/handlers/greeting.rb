module Alice

  module Handlers

    class Greeting

      def self.process(sender, command)
        Alice::Response.new(content: Alice::Util::Randomizer.greeting(sender), kind: :action)
      end

    end

  end

end