module Handlers

  class Bio

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      if command_string.quoted_text
        update_bio(command_string.quoted_text)
      else
        return_bio
      end
    end

    def update_bio(quoted)
      if quoted.length == 0
        message.sender.bio.delete
        message.set_response("I've erased your bio from my notebook.")
      else
        message.sender.update_bio(quoted)
        message.set_response("I've recorded the details in my notebook.")
      end
    end

    def delete_bio
    end

    def return_bio
      message.set_response(subject.formatted_bio || "I can't seem to remember anything about them.")
    end

    private

    def subject
      ::User.from(command_string.content) || message.sender
    end

  end

end
