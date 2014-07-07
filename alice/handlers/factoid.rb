module Handlers

  class Factoid

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      message.set_response(message.sender.set_factoid(command_string.predicate))
    end

    def get
      message.set_response(subject.random_factoid.formatted)
    end

    private

    def subject
      ::User.from(command_string.subject) || ::User.new
    end

  end

end
