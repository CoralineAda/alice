module Behavior

  module HandlesCommands

    def self.included(klass)
      klass.send(:attr_accessor, :message)
      klass.extend(ClassMethods)
    end

    def command_string
      Message::CommandString.new(self.message.trigger)
    end

    module ClassMethods
      def process(message, method)
        method ||= :process
        handler = new(message: message)
        handler.public_send(method)
      end
    end

  end

end
