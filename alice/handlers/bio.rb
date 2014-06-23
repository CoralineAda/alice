module Handlers

  class Bio

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      message.response = ::Bio.for(message.trigger).formatted
      message
    end

  end

end