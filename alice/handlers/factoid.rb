module Handlers

  class Factoid

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      message.sender.set_factoid(command_string.fragment)
      message.response = "Got it!"
    end

    def get
      factoid = ::Factoid.about(command.predicate).try(:formatted)
      if context = Context.find_or_create(command.predicate)
        context.current!
      end
      if factoid
        message.response = factoid
      elsif context
        message.response = context.describe
      else
        message.response = Util::Randomizer.got_nothing
      end
    end

    private

    def subject
      ::User.from(command.subject)
    end

  end

end
