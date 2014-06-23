module Handlers

  class Factoid

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      message.response = ::Factoid.about(message.trigger).formatted
      message
    end

  end

end