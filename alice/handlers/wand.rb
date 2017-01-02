module Handlers

  class Wand

    include PoroPlus
    include Behavior::HandlesCommands

    def use
      if wand && message.sender.wands.include?(wand)
        message.response = wand.employ
      else
        message.response = "I don't think you have that."
      end
    end

    private

    def wand
      ::Wand.from(command.subject)
    end

  end

end
