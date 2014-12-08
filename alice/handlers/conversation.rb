module Handlers

  class Conversation

    include PoroPlus
    include Behavior::HandlesCommands

    attr_accessor :current_context

    def initialize(*args)
      self.current_context = global_context
      super
    end

    def converse
      text ||= fact_from(subject) if set_context_from_subject
      text ||= fact_from(predicate.split.last)
      text ||= fact_from(predicate) if set_context_from_predicate
      text ||= default_response(predicate)
      set_response(text)
    end

    def give_context
      text = if self.current_context
        "I was just talking about #{self.current_context.topic}."
      else
        "I wasn't talking about anything in particular."
      end
      set_response(text)
    end

    private

    def context_from(topic, subtopic=nil)
      self.current_context = Alice::Context.any_from(topic.downcase, subtopic)
      self.current_context ||= Alice::Context.find_or_create(topic.downcase)
      self.current_context ||= global_context
      self.current_context
    end

    def default_response(topic=nil)
      if self.current_context && topic != self.current_context.topic
        text = topic.split.map do |word|
          fact = fact_from(topic)
          fact = "That's all I've got" if fact && self.current_context.has_spoken_about?(fact)
          fact
        end.compact.first
        Alice::Util::Logger.info("*** text is currently #{text}")

        if text.nil? && set_context_from_predicate
          text ||= self.current_context.describe
        else
          text ||= Alice::Util::Randomizer.talking_about(self.current_context.topic)
          text ||= "I don't know what we're talking about."
        end
      else
        text = "I've told you all I know for now. Ask me about something else?"
      end
      text ||= "I have no idea."
      text
    end

    def fact_from(topic)
      return unless self.current_context
      return unless topic
      fact = self.current_context.declarative_fact(topic.downcase)
      fact ||= self.current_context.relational_fact(topic.downcase)
    end

    def global_context
      @global_context ||= Alice::Context.current
    end

    def predicate
      @predicate ||= command_string.predicate
    end

    def set_context_from_predicate
      return unless predicate
      if self.current_context = context_from(predicate.downcase)
        return false if self.current_context == global_context
        update_context
        return true
      end
    end

    def set_context_from_subject
      return unless subject
      if self.current_context = context_from(subject.downcase)
        return false if self.current_context == global_context
        update_context
        return true
      end
    end

    def set_response(text)
      return unless text
      message.set_response((text + ".").gsub(/\.\.$/, '.'))
    end

    def subject
      @subject ||= command_string.subject
    end

    def update_context
      if self.current_context
        self.current_context.current!
      else
        self.current_context = global_context
      end
      return if self.current_context == global_context
      Alice::Util::Logger.info("*** Switching context to #{self.current_context.topic}")
    end

  end

end
