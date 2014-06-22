module Handlers

  class Beverage

    include PoroPlus
    include Behavior::HandlesCommands

    def brew
      message.response = ::Beverage.brew(command_string.predicate, message.sender)
      message
    end

    def drink
      if beverage = ::Beverage.for_user(message.sender).from(command_string.predicate)
        message.response = beverage.drink
      else
        message.response = not_here_response
      end
      message
    end

    def spill
      message.response = "SPILLING for #{message.sender_nick}"
      message
    end

    def list
      message.response = "LISTING for #{message.sender_nick}"
      message
    end

    private

    def not_here_response
      Alice::Util::Randomizer.not_here(command_string.predicate)
    end

  end

end
