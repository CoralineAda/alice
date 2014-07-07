module Handlers

  class OH

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      message.set_response(::OH.from(command_string.predicate))
    end

    def get
      message.set_response(::OH.sample)
    end

  end

end
