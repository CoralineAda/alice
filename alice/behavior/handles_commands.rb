module Behavior

  module HandlesCommands

    def self.included(klass)
      klass.send(:attr_accessor, :message)
      klass.send(:attr_accessor, :command)
      klass.extend(ClassMethods)
    end

    def command_string
      Message::CommandString.new(self.message.trigger)
    end

    module ClassMethods
      def process(message, command, method)
        method ||= :process
        handler = new(message: message, command: command)
        handler.public_send(method)
      end
    end

  end

end
