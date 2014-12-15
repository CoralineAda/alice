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

    def eat
      item && message.set_response(item.eat)
    end

    def take
      if item = loose_item
        message.set_response(item.transfer_to(message.sender))
      elsif Place.current.description =~ /#{command_string.subject}/i
        message.set_response(Util::Randomizer.cant_pick_up(command_string.subject))
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
        message.set_response("Got it! It's set.")
      end
    end

    def forge
      message.set_response(::Item.forge(command_string.raw_command, message.sender))
    end

    def give
      if recipient = User.from(command_string.predicate)
        thing = beverage_for_user || item_for_user
        if recipient.accepts_gifts?
          message.set_response(thing.transfer_to(recipient))
        else
          message.set_response("Sorry, they're not accepting gifts right now.")
        end
      else
        message.set_response("Sorry, I don't see #{command_string.predicate} here right now.")
      end
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
      PATTERN = /^.+\s(?<key>\S+) of .+ to (?<value>.+)$/

      attr_reader :string

      def initialize(string)
        @string = string
      end

      def key
        match && match[:key]
      end

      def value
        match && match[:value]
      end

      def match
        @match ||= self.string.match(PATTERN)
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

    def beverage_for_user
      user = message.sender
      ::Beverage.for_user(user).from(command_string.subject) ||
        ::Beverage.for_user(user).from(command_string.subject.split(':')[0]) ||
        ::Beverage.for_user(user).from(command_string.raw_command)
    end

    def item
      @item ||= ::Item.from(command_string.subject) ||
                  ::Item.from(command_string.subject.split(':')[0]) ||
                  ::Item.from(command_string.raw_command) ||
                  ::Item.ephemeral
    end

  end

end
