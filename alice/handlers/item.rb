# TODO: find, hide, eat methods

module Handlers

  class Item

    include PoroPlus
    include Behavior::HandlesCommands

    def destroy
      message.response = item.destruct
      message
    end

    def drop
      message.response = item_for_user.drop
      message
    end

    def examine
      message.response = item.describe
      message
    end

    # def find
    #   # message.response = ::Inventory.for(message)
    #   # message
    # end

    def forge
      message.response = ::Item.forge(command_string.predicate, message.sender)
      message
    end

    def give
      message.response = item_for_user.transfer_to(command_string.predicate)
      message
    end

    # def hide
    #   message.response = "Sorry, not yet implemented."
    #   message
    # end

    def play
      message.response = item_for_user.play
      message
    end

    def steal
      message.response = message.sender.steal(command_string.predicate)
      message
    end

    private

    def item_for_user
      message.sender.items.include?(item) ? item : Item.ephemeral
    end

    def item
      @item ||= ::Item.from(command_string.subject) || Item.ephemeral
    end

  end

end
