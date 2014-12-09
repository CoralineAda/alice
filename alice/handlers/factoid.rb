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
      if context = Context.find_or_create(command_string.predicate)
        context.current!
      end
      if factoid
        message.set_response(factoid)
      elsif context
        message.set_response(context.describe)
      else
        message.set_response(Alice::Util::Randomizer.got_nothing)
      end
    end

    private

    def subject
      ::User.from(command_string.subject)
    end

  end

end
