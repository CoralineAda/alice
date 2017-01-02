module Handlers
  class OH

    include PoroPlus
    include Behavior::HandlesCommands

    def set
      ::OH.from(command.subject)
      message.response = "I'll remember that."
    end

    def get
      message.response = "Someone said \"#{::OH.sample.text}\""
    end

  end
end
