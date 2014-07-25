module Handlers

  class Machine

    include PoroPlus
    include Behavior::HandlesCommands

    def use
      message.set_response(machine.use(command_string.subject))
    end

    private

    def machine
      ::Machine.from(command_string.predicate)
    end

  end

end
