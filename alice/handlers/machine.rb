module Handlers

  class Machine

    include PoroPlus
    include Behavior::HandlesCommands

    def catalog
      message.set_response(::Machine.catalog)
    end

    def install
      message.set_response(machine.install)
    end

    def use
      message.set_response(machine.use(action))
    end

    private

    def action
      command_string.predicate
    end

    def machine
      ::Machine.from(command_string.subject)
    end

  end

end
