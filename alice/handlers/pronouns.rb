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
      message.sender.set_pronouns(command_string.fragment)
      Alice::Util::Logger.info "*** Command subject is #{command.subject}"
      message.response = "Thanks! I'll remember this."
    end

    def get
      user = message.sender
      response = "I have your  #{user.pronouns.downcase}. "
      response << "If this is incorrect, set them with !pronouns for whatever fits you best. "
      response << "For example: they/them/their/theirs: "
      response << "/They/ are here. I see /them/. This is /their/ satchel and the wine is /theirs/."
      message.response = response
    end

    private

  end

end
