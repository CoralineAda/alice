module Handlers

  class Actor

    include PoroPlus
    include Behavior::HandlesCommands

    def summon
      message.set_response(subject.summon_for(message.sender_nick, message.is_sudo?))
    end

    def talk
      message.set_response("#{subject.proper_name} says, \"#{subject.speak}\"")
    end

    private

    def subject
      ::Actor.from(command_string.subject) || ::Actor.unknown
    end

  end

end
