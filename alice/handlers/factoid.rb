module Handlers

  class Factoid

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      message.sender.set_factoid(command_string.raw_command)
      message.set_response("Got it!")
    end

    def get
      factoid = ::Factoid.about(command_string.predicate).try(:formatted)
      # factoid ||= ::Factoid.about(command_string.subject)
      factoid ||= ::Topic.new(command_string.predicate).support
      message.set_response(factoid || "I've got nothing.")
    end

    private

    def subject
      ::User.from(command_string.subject)
    end

  end

end
