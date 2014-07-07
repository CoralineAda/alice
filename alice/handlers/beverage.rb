module Handlers

  class Beverage

    include PoroPlus
    include Behavior::HandlesCommands

    def brew
      message.set_response(::Beverage.brew(command_string.predicate, message.sender))
    end

    def drink
      message.set_response(::Beverage.consume(command_string.predicate, message.sender))
    end

  end

end
