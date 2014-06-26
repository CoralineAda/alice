module Handlers

  class Item

    include PoroPlus
    include Behavior::HandlesCommands

    def find
      # message.response = ::Inventory.for(message)
      # message
    end

    def examine
    end

    def give
      message.response = item.transfer_to(command_string.predicate)
      message
    end

    def steal
      message.response = message.sender.steal(command_string.predicate)
      message
    end

    private

    def item
      ::Item.from(command_string.subject)
    end

  end

end
