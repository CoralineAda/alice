module Handlers

  class Greeting

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      message.response = ::Greeting.greet(message)
      message
    end

  end

end
