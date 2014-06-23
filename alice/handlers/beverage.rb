module Handlers

  class Beverage

    include PoroPlus
    include Behavior::HandlesCommands

    def brew
      message.response = ::Beverage.brew(command_string.predicate, message.sender)
      message
    end

    def drink
      message.response = ::Beverage.consume(command_string.predicate, message.sender)
      message
    end

  end

end
