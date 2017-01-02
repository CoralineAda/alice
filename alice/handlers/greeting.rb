module Handlers

  class Greeting

    include PoroPlus
    include Behavior::HandlesCommands

    def greet_sender
      message.response = Util::Randomizer.greeting(subject.current_nick)
    end

    private

    def subject
      ::User.from(command.predicate) || message.sender
    end

  end

end
