module Handlers

  class Twitter

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      message.sender.set_twitter_handle(command_string.subject)
      message.response = "I'll remember that."
    end

    def get
      return unless subject
      message.response = subject.formatted_twitter_handle
    end

    private

    def subject
      ::User.from(command_string.subject)
    end

  end

end
