module Handlers

  class Bio

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      if quoted = command_string.quoted_text
        if quoted.length > 0
          message.sender.update_bio(quoted)
          message.set_response("I've recorded the details in my notebook.")
        else
          message.sender.bio.delete
          message.set_response("I've erased your bio from my notebook.")
        end
      elsif bio = subject.formatted_bio
        message.set_response(bio)
      else
        message.set_response("I can't seem to find anything about that.")
      end
    end

    private

    def subject
      ::User.from(command_string.content) || message.sender
    end

  end

end
