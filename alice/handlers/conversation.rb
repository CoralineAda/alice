require 'active_support/inflector'

module Handlers

  class Conversation

    include PoroPlus
    include Behavior::HandlesCommands
    include ActiveSupport

    def converse
      unless text = fact_from(predicate.split.last)
        set_context_from_predicate
        unless text = fact_from(predicate.split.last)
          context_stack.pop
        end
        text ||= default_response(predicate)
      end
      set_response(text)
    end

    def give_context
      text = if current_context
        "I was just talking about #{current_context.topic}."
      else
        "I wasn't talking about anything in particular."
      end
      set_response(text)
    end

    private

    def context_stack
      @context_stack ||= Array.new([global_context])
    end

    def current_context
      context_stack.last || Context.current
    end

    def context_from(topic, subtopic=nil)
      new_context = Context.from(topic.downcase, subtopic)
      new_context ||= Context.find_or_create(topic.downcase)
      new_context ||= global_context
      update_context(new_context)
    end

    def default_response(topic)
      return Util::Randomizer.i_dont_know if facts_exhausted?(topic)
      return "I don't know what we're talking about" if no_context?
      return Util::Randomizer.talking_about(current_context.topic)
    end

    def no_context?
      current_context.nil?
    end

    def facts_exhausted?(topic)
      fact_from(topic, false).nil?
    end

    def fact_from(topic, speak=true)
      return unless current_context
      return unless topic

      fact = current_context.declarative_fact(topic.downcase, speak)
      fact ||= current_context.declarative_fact(topic.downcase.pluralize, speak)
      fact ||= current_context.declarative_fact(topic.downcase.singularize, speak)

      fact ||= current_context.relational_fact(topic.downcase, speak)
      fact ||= current_context.relational_fact(topic.downcase.pluralize, speak)
      fact ||= current_context.relational_fact(topic.downcase.singularize, speak)

    end

    def global_context
      @global_context ||= Context.current
    end

    def predicate
      @predicate ||= command_string.predicate
    end

    def set_context_from_predicate
      return unless predicate && predicate.present?
      if new_context = context_from(predicate.downcase)
        update_context(new_context)
      end
    end

    def set_context_from_subject
      return unless subject
      return if (command_string.components & Grammar::LanguageHelper::PRONOUNS).any?
      update_context(context_from(subject.downcase))
    end

    def set_response(text)
      return unless text
      message.set_response((text + ".").gsub(/\.\.$/, '.'))
    end

    def subject
      @subject ||= command_string.subject
    end

    def update_context(new_context)
      return unless new_context
      context_stack.push(new_context)
      new_context.current!
      Alice::Util::Logger.info("*** Switching context to #{new_context.topic}")
    end

  end

end
