module Handlers

  class Bio

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      message.sender.update_bio(command_string.subject)
      message.set_response("records the details in her notebook.")
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
