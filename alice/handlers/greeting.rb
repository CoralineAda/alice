module Handlers

  class Greeting

    include PoroPlus
    include Behavior::HandlesCommands

    def greet_sender
      message.response = Util::Randomizer.greeting(subject.primary_nick)
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
