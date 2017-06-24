module Handlers

  class Bio

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      handle_bio(command_string.content.to_s, message.sender)
    end

    private

    def handle_bio(quoted, sender)
      if command_string.verb == "bio"
        if command_string.predicate.present?
          message.sender.update_bio(command_string.predicate)
          message.response = "I've recorded the details in my notebook."
        else
          message.response = sender.formatted_bio
        end
      else
        user = ::User.from(command_string.components.join(' '))
        message.response = user.formatted_bio if user
      end
      message.response ||= "I don't know anyone by that name."
    end

    def update_bio(quoted)
      return unless quoted
    end

  end

end
