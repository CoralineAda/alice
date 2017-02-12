module Handlers

  class Beverage

    include PoroPlus
    include Behavior::HandlesCommands

    def brew
      message.response = ::Beverage.brew(command.subject, message.sender)
    end

    def drink
      message.response = ::Beverage.consume(command.subject, message.sender)
    end

    def give
      if user = User.from(command.predicate)
        if user.accepts_gifts?
          message.response = item_for_user.transfer_to(user)
        else
          message.response = "Sorry, they're not accepting drunks right now."
        end
      else
        message.response = "Sorry, I don't see #{command.predicate} here right now."
      end
    end

    def item_for_user
      user = message.sender
      ::Beverage.for_user(user).from(command.subject) ||
        ::Beverage.for_user(user).from(command.subject.split(':')[0]) ||
        ::Beverage.for_user(user).from(command_string.fragment) ||
        ::Beverage.ephemeral
    end

  end

end
