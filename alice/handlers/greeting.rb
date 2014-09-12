module Handlers

  class Greeting

    include PoroPlus
    include Behavior::HandlesCommands

    def greet_sender
      message.set_response(::Greeting.greet(subject.current_nick))
    end

    private

    def subject
      ::User.from(command_string.predicate) || message.sender
    end

  end

end
