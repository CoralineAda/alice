require 'pry'
module Behavior

  module HandlesCommands

    def self.included(klass)
      klass.send(:attr_accessor, :message)
      klass.extend(ClassMethods)
    end

    def command_string
      CommandString.new(self.message.trigger)
    end

    module ClassMethods
      def process(message, method=:process)
        return unless method
        new(message: message).public_send(method)
      end
    end

  end

end
