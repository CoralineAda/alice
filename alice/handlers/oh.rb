module Handlers

  class Oh

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      message.response = ::Oh.random
      message
    end

  end

end