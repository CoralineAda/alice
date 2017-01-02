module Handlers

  class Actor

    include PoroPlus
    include Behavior::HandlesCommands

    def summon
      message.response = subject.summon_for(message.sender_nick, message.is_sudo?)
    end

    def talk
      if subject
        message.response = "#{subject.proper_name} says, \"#{subject.speak}\""
      else
        context = Context.current
        context ||= Context.with_keywords.sample
        if context
          message.response = "Hmm. Today's topic is '#{context.topic}'."
        end
      end
    end

    private

    def subject
      @actor ||= ::Actor.from(command.subject)
    end

  end

end
