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

    def should_respond?
      return true if self.command_string.content[0] == "!"
      return true if self.command_string.content =~ /#{ENV['BOT_SHORT_NAME']}/i
      false
    end

    module ClassMethods
      def process(message, method)
        method ||= :process
        handler = new(message: message)
        handler.public_send(method) if handler.should_respond?
      end
    end

  end

end
