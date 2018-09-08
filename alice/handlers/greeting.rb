module Handlers

  class Greeting

    include PoroPlus
    include Behavior::HandlesCommands

    def greet_sender
      if subject
        greetee = subject.primary_nick
      elsif command_string.fragment.include?("to")
        greetee = command_string.fragment.split("to")[1]
      end
      greetee ||= message.sender.primary_nick
      message.response = Util::Randomizer.greeting(greetee)
    end

    private

    def subject
      if command.subject.is_a?(::User)
        !command.subject.is_bot? && command.subject || message.sender
      else
        command.subject != ENV['BOT_NAME'] && ::User.from(command.subject)
      end
    end

  end

end
