module Handlers

  class Actor

    include PoroPlus
    include Behavior::HandlesCommands

    def summon
      message.set_response(subject.summon_for(message.sender_nick, message.is_sudo?))
    end

    def talk
      if subject
        message.set_response("#{subject.proper_name} says, \"#{subject.speak}\"")
      else
        context = Context.current
        context ||= Context.with_keywords.sample
        if context
          message.set_response("Hmm. Today's topic is '#{context.topic}'.")
        end
      end
    end

    private

    def subject
      @actor ||= ::Actor.from(command_string.subject)
    end

  end

end
