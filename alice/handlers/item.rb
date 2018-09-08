# TODO: find, hide, eat methods

module Handlers

  class Item

    include PoroPlus
    include Behavior::HandlesCommands

    def destroy
      message.response = item_for_user.destruct
    end

    def drop
      message.response = item_for_user.drop
    end

    def hide
      if item = item_for_user
        message.response = item.hide
      end
    end

    def eat
      item && message.response = item.eat
    end

    def take
      if loose_item
        message.response = loose_item.transfer_to(message.sender)
      elsif Place.current.description =~ /#{command.subject}/i
        message.response = Util::Randomizer.cant_pick_up(command.subject)
      else
        message.response = "I don't see that here."
      end
    end

    # def find
    #   # message.response = ::Inventory.for(message)
    #   # message
    # end

    def set
      return unless this_item = item_for_user
      if this_item.set_property(AttributeParser.new(command_string.content))
        message.response = "Oh, nice."
      end
    end

    def forge
      message.response = ::Item.forge(command_string.fragment, message.sender)
    end

    def give
      if recipient = ::User.from(command.predicate) || ::Actor.from(command.predicate)
        thing = beverage_for_user || item_for_user
        if recipient.accepts_gifts?
          message.response = thing.transfer_to(recipient)
        else
          message.response = "Sorry, they're not accepting gifts right now."
        end
      else
        message.response = "Sorry, I don't see #{command.predicate} here right now."
      end
    end

    def play
      message.response = (loose_item || item_for_user).play
    end

    def read
      if readable = loose_item || item_for_user
        message.response = readable.read
      elsif readable = item && item.owner && item.owner.place_id
        message.response = "You can't read that, it's in #{item.owner.primary_nick}'s backpack."
      else
        message.response = "There's nothing like that here. Did you forget your glasses maybe?"
      end
    end

    def steal
      message.response = message.sender.steal(item)
    end

    class AttributeParser
      PATTERN = /^.+?\s(?<key>\S+) of .+ to (?<value>.+)$/

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
      present_items = ::Item.where(place_id: Place.current.id).to_a
      keywords = [command_string.fragment.split, command.subject, command.predicate].flatten.compact.uniq
      potential_items = keywords.map{ |keyword| ::Item.like_all(keyword)}.flatten.compact
      (present_items & potential_items).sample
    end

    def item_for_user
      user = message.sender
      available_items = ::Item.for_user(user).to_a
      keywords = [command_string.fragment.split, command.subject, command.predicate].flatten.compact.uniq
      potential_items = keywords.map{ |keyword| ::Item.like_all(keyword)}.flatten.compact
      (available_items & potential_items).first
    end

    def beverage_for_user
      user = message.sender
      ::Beverage.for_user(user).from(command.subject) ||
        ::Beverage.for_user(user).from(command.subject.split(':')[0]) ||
        ::Beverage.for_user(user).from(command_string.fragment)
    end

    def item
      return @item if @item
      @item = ::Item.from(command_string.fragment)
      if command.subject
        @item ||= ::Item.from(command.subject) || ::Item.from(command.subject.split(':')[0])
      end
      if command.predicate
        @item ||= ::Item.from(command.predicate)
      end
      @item || ::Item.ephemeral
    end

  end

end
