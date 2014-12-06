module Handlers

  class Conversation

    include PoroPlus
    include Behavior::HandlesCommands

    def converse
      if this_topic = topic_from_subject
        text = this_topic.relational_fact(command_string.predicate) || this_topic.describe
      elsif this_topic = topic_from_predicate || Alice::Context.current
        text = this_topic.relational_fact(command_string.predicate.split.last)
      end
      this_topic && this_topic.current!
      message.set_response(text.to_s)
    end

    def topic_from_predicate
      command_string.predicate && this_topic = Alice::Context.any_from(command_string.subject, command_string.predicate)
    end

    def topic_from_subject
      Alice::Context.any_from(command_string.subject)
    end

  end

end
