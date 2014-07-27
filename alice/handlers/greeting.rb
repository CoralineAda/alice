module Handlers

  class Greeting

    include PoroPlus
    include Behavior::HandlesCommands

    def greet_sender
      message.set_response(::Greeting.greet(message.sender_nick))
    end

    def greet_other
      message.set_response(::Greeting.greet(subject.current_nick))
    end

    private

    def subject
      ::User.from(command_string.predicate) || ::User.new
    end

  end

end
