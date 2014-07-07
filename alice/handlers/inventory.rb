module Handlers

  class Inventory

    include PoroPlus
    include Behavior::HandlesCommands

    def inventory
      message.set_response(message.sender.inventory)
    end

  end

end
