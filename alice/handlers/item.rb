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

    def hide
      if item = item_for_user
        message.set_response(item.hide)
      end
    end

    def take
      if item = loose_item
        message.set_response(item.transfer_to(message.sender))
      else
        message.set_response("I don't see that here.")
      end
    end

    # def find
    #   # message.response = ::Inventory.for(message)
    #   # message
    # end

    def set
      return unless this_item = item_for_user
      if this_item.set_property(AttributeParser.new(command_string.content))
        message.set_response = "Got it! It's set."
      end
    end

    def forge
      message.set_response(::Item.forge(command_string.raw_command, message.sender))
    end

    def give
      message.set_response(item_for_user.transfer_to(User.from(command_string.predicate)))
    end

    def play
      message.set_response((loose_item || item_for_user).play)
    end

    def read
      message.set_response((loose_item || item_for_user).read)
    end

    def steal
      message.set_response(message.sender.steal(item))
    end

    class AttributeParser
      PATTERN = /^.+property\s*(?<key>\S+)\s+to\s+(?<value>.+)$/

      attr_reader :string

      def initialize(string)
        @string = string
      end

      def key
        self.string.match(PATTERN)[:key]
      end

      def value
        self.string.match(PATTERN)[:value]
      end
    end

    private

    def loose_item
      item.place && item.place.items.include?(item) && item
    end

    def item_for_user
      user = message.sender
      ::Item.for_user(user).from(command_string.subject) ||
        ::Item.for_user(user).from(command_string.subject.split(':')[0]) ||
        ::Item.for_user(user).from(command_string.raw_command) ||
        ::Item.ephemeral
    end

    def item
      @item ||= ::Item.from(command_string.subject) ||
                  ::Item.from(command_string.subject.split(':')[0]) ||
                  ::Item.from(command_string.raw_command) ||
                  ::Item.ephemeral
    end

  end

end
