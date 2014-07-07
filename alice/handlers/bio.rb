module Handlers

  class Bio

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      message.set_response(message.sender.update_bio(command_string.predicate))
    end

    def get
      message.set_response(subject.formatted_bio)
    end

    private

    def subject
      ::User.from(command_string.predicate) || ::User.new
    end

  end

end
