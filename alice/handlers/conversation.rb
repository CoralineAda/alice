require 'active_support/inflector'

module Handlers

  class Conversation

    include PoroPlus
    include Behavior::HandlesCommands
    include ActiveSupport

    def converse
      set_context_from_subject_or_predicate
      return unless current_context
      unless text = fact_from(current_context.topic) || description_from_context
        context_stack.pop
        text = default_response(current_context.topic)
      end
      text = text.sub(/\?\./, '?')
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
      @context_stack ||= Array.new([current_context])
    end

    def current_context
      context_stack.last || Context.current
    end

    def context_from(topic, subtopic=nil)
      new_context = Context.find_or_create(topic.downcase, self.message.trigger.gsub(ENV['BOT_NAME'], ""))
      new_context ||= current_context
      update_context(new_context)
    end

    def default_response(topic)
      return "I don't know what we're talking about" if no_context?
      return Util::Randomizer.i_dont_know if facts_exhausted?(topic)
      return Util::Randomizer.talking_about(current_context.topic)
    end

    def description_from_context
      current_context && current_context.describe
    end

    def no_context?
      current_context.nil?
    end

    def facts_exhausted?(topic)
      fact_from(topic, false).nil?
    end

    def fact_from(topic, speak=true)
      return unless current_context && topic
      topic = topic.downcase
      fact = current_context.declarative_fact(topic, speak)
      fact ||= current_context.declarative_fact(topic.pluralize, speak)
      fact ||= current_context.declarative_fact(topic.singularize, speak)
      fact ||= current_context.relational_fact(topic, speak)
      fact ||= current_context.relational_fact(topic.pluralize, speak)
      fact ||= current_context.relational_fact(topic.singularize, speak)
    end

    def current_context
      Context.current
    end

    def subject_or_predicate
      subject || predicate
    end

    def subject
      @subject ||= command.subject unless command.subject.is_bot?
    end

    def predicate
      @predicate = User.from(command.predicate)
      @predicate ||= command.predicate
    end

    def set_context_from_subject_or_predicate
      set_context_from_predicate || set_context_from_subject
    end

    def set_context_from_predicate
      return unless predicate.present?
      return if (command_string.components & Grammar::LanguageHelper::PRONOUNS).count > 0
      update_context(context_from(predicate.respond_to?(:downcase) && predicate.downcase || predicate.name.downcase))
      true
    end

    def set_context_from_subject
      return unless subject
      return if (command_string.components & Grammar::LanguageHelper::PRONOUNS).any?
      update_context(context_from(subject.respond_to?(:downcase) && subject.downcase || subject.name.downcase))
      true
    end

    def set_response(text)
      return unless text
      text = ((text + ".").gsub(/\.\.$/, '.')).sub('!.', '!').sub('?.', '?')
      message.response = text
    end

    def subject
      @subject ||= command.subject
    end

    def update_context(new_context)
      return unless new_context
      context_stack.push(new_context)
      new_context.current!
      Alice::Util::Logger.info("*** Switching context to #{new_context.topic}")
    end

  end

end
