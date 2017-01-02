module Handlers

  class Greeting

    include PoroPlus
    include Behavior::HandlesCommands

    def greet_sender
      message.response = Util::Randomizer.greeting(subject.current_nick)
    end

    private

    def subject
      return command.subject if command.subject.is_a? ::User
      ::User.from(command.subject) || message.sender
    end

  end

end
