module Handlers

  class Twitter

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      message.sender.set_twitter_handle(command.subject)
      message.response = "I'll remember that."
    end

    def get
      return unless subject
      message.response = subject.formatted_twitter_handle
    end

    private

    def subject
      ::User.from(command.subject)# || ::User.from(Context.current.topic)
    end

  end

end
