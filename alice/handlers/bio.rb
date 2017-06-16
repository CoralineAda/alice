module Handlers

  class Bio

    include PoroPlus
    include Behavior::HandlesCommands

    def process
      handle_bio(command_string.content.to_s, message.sender)
    end

    private

    def handle_bio(quoted, sender)
      if subject && (command && command.predicate != "bio" && command_string.content !~ /^who is/)
        update_bio(command_string.predicate)
      else
        if command_string.content[0] == "!"
          return_bio(sender)
        elsif subject
          Context.from(subject.primary_nick).current!
          return_bio(subject)
        else
          message.response = "I don't know anyone by that name."
        end
      end
    end

    def return_bio(sender)
      who = subject
      who ||= sender
      text = "I don't know who that is." unless who
      text = who.formatted_bio if who && who.formatted_bio
      text ||= "I don't seem to know anything about them."
      message.response = text
    end

    def subject
      ::User.from(command_string.components.join(' '))
    end

    def update_bio(quoted)
      return unless quoted
      message.sender.update_bio(quoted)
      message.response = "I've recorded the details in my notebook."
    end

  end

end
