# TODO: find, hide, eat methods

module Handlers

  class Item

    include PoroPlus
    include Behavior::HandlesCommands

    def destroy
      message.set_response(item_for_user.destruct)
    end

    def drop
      message.set_response(item_for_user.drop)
    end

    def take
      if item = loose_item
        message.set_response(item.transfer_to(message.sender))
      else
        message.set_repsonse("I don't see that here.")
      end
    end

    # def find
    #   # message.response = ::Inventory.for(message)
    #   # message
    # end

    def forge
      message.set_response(::Item.forge(command_string.subject, message.sender))
    end

    def give
      message.set_response(item_for_user.transfer_to(User.from(command_string.predicate)))
    end

    # def hide
    #   message.response = "Sorry, not yet implemented."
    #   message
    # end

    def play
      message.set_response((loose_item || item_for_user).play)
    end

    def read
      message.set_response((loose_item || item_for_user).read)
    end

    def steal
      message.set_response(message.sender.steal(item))
    end

    private

    def loose_item
      item.place && item.place.items.include?(item) && item
    end

    def item_for_user
      return item if message.sender.items.include?(item)
      return item if message.sender.beverages.include?(item)
      return item if message.sender.wands.include?(item)
    end

    def item
      @item ||= ::Item.from(command_string.subject) || ::Item.ephemeral
    end

  end

end
