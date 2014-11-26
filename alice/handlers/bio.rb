module Handlers

  class Bio

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      handle_bio(command_string.content.to_s)
    end

    def handle_bio(quoted)
      # if quoted.empty? || User.from(quoted)
      #   return_bio
      # else
        update_bio(command_string.raw_command)
      # end
    end

    def update_bio(quoted)
      message.sender.update_bio(quoted)
      message.set_response("I've recorded the details in my notebook.")
    end

    def return_bio
      message.set_response(subject.formatted_bio || "I can't seem to remember anything about them.")
    end

    private

    def subject
      ::User.from(command_string.components.join(' ')) || message.sender
    end

  end

end
