module Handlers

  class Pronouns

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      message.sender.pronouns = command_string.subject
      message.set_response("I'll remember that.")
    end

    def get
      return unless subject
      message.set_response(subject.pronouns)
    end

    private

    def subject
      ::User.from(command_string.subject)
    end

  end

end
