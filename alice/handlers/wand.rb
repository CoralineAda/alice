module Handlers

  class Wand

    include PoroPlus
    include Behavior::HandlesCommands

    def use
      if wand && message.sender.wands.include?(wand)
        message.set_response(wand.employ)
      else
        message.set_response("I don't think you have that.")
      end
    end

    private

    def wand
      ::Wand.from(command_string.subject)
    end

  end

end
