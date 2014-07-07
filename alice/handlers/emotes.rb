# FIXME
module Handlers

  class Emotes

    include PoroPlus
    include Behavior::HandlesCommands

    def foo
      message.set_response("something")
    end

    private

    def subject
      ::User.from(command_string.predicate) || ::User.new
    end

  end

end
