module Handlers

  class Factoid

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      message.sender.set_factoid(command_string.predicate)
      message.set_response("Got it!")
    end

    def get
      factoid = ::Factoid.about(command_string.predicate)
      factoid ||= ::Factoid.about(command_string.subject)
      message.set_response(factoid.formatted) if factoid
    end

    private

    def subject
      ::User.from(command_string.subject)
    end

  end

end
