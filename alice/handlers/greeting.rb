module Handlers

  class Greeting

    include PoroPlus
    include Behavior::HandlesCommands

    def greet_sender
      greetee = subject.primary_nick
      if command_string.fragment.include?("to")
        greetee = command_string.fragment.split("to")[1]
      end
      message.response = Util::Randomizer.greeting(greetee)
    end

    private

    def subject
      if command.subject.is_a?(::User)
        !command.subject.is_bot? && command.subject || message.sender
      else
        command.subject != ENV['BOT_NAME'] && ::User.from(command.subject) || message.sender
      end
    end

  end

end
