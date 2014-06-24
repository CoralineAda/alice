module Handlers

  class Inventory

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      message.response = ::Inventory.for(message)
      message
    end

  end

end
