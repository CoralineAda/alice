module Handlers

  class Actor

    include PoroPlus
    include Behavior::HandlesCommands

    def talk
      message.set_response(subject.speak)
    end

    private

    def subject
      ::Actor.from(command_string.predicate) || ::Actor.unknown
    end

  end

end
