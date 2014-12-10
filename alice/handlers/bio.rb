module Handlers

  class Bio

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      handle_bio(command_string.content.to_s)
    end

    private

    def handle_bio(quoted)
      if command_string.predicate && ! command_string.content.include?("who is")
        update_bio(command_string.raw_command)
      else
        return_bio
      end
    end

    def return_bio
      return unless subject
      if subject.formatted_bio
        message.set_response(subject.formatted_bio)
      else
        message.set_response(Util::Randomizer.got_nothing)
      end
    end

    def subject
      ::User.from(command_string.components.join(' '))
    end

    def update_bio(quoted)
      return unless quoted
      message.sender.update_bio(quoted)
      message.set_response("I've recorded the details in my notebook.")
    end

  end

end
