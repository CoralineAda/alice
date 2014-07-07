module Handlers

  class Twitter

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      message.set_response(subject.set_twitter_handle(command_string.predicate))
    end

    def get
      message.set_response(subject.formatted_twitter_handle)
    end

    private

    def subject
      ::User.from(command_string.subject) || ::User.new
    end

  end

end
