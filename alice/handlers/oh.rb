module Handlers
  class OH

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      ::OH.from(command_string.subject)
      message.set_response("I'll remember that.")
    end

    def get
      message.set_response("Someone said \"#{::OH.sample.text}\"")
    end

  end
end
