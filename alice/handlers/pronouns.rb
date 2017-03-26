module Handlers

  class Pronouns

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      if command_string.content.include?("/")
        set
      else
        get
      end
    end

    def set
      message.sender.set_pronouns(command.subject)
      Alice::Util::Logger.info "*** Command subject is #{command.subject}"
      message.response = "Thanks! I'll remember this."
    end

    def get
      if subject
        message.response = subject.pronouns
      else
        user = ::User.from(message.sender_nick)
        response = "I have your  #{user.pronouns.downcase}. "
        response << "If this is incorrect, set them with !pronouns for whatever fits you best. "
        response << "For example: they/them/their/theirs: "
        response << "/They/ are here. I see /them/. This is /their/ satchel and the wine is /theirs/."
        message.response = response
      end
    end

    private

    def subject
      ::User.from(command.subject)
    end

  end

end
