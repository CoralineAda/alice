module Handlers

  class Bio

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      handle_bio(command_string.content.to_s)
    end

    def handle_bio(quoted)
      if ([command_string.predicate.downcase] & [subject.primary_nick, subject.alt_nicks].flatten).any?
        return_bio
      else
        update_bio(command_string.raw_command)
      end
    end

    def update_bio(quoted)
      return unless quoted
      message.sender.update_bio(quoted)
      message.set_response("I've recorded the details in my notebook.")
    end

    def return_bio
      if subject.formatted_bio
        message.set_response(subject.formatted_bio)
      else
        message.set_response(Alice::Util::Randomizer.got_nothing)
      end
    end

    private

    def subject
      ::User.from(command_string.components.join(' ')) || message.sender
    end

  end

end
