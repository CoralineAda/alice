module Handlers
  class Alpha

    include PoroPlus
    include Behavior::HandlesCommands

    def answer_question
      message.response = answer || Util::Randomizer.i_dont_know
    end

    private

    def answer
      if result = Parser::Alpha.new(sentence).answer
        result
      else
        sorted_answers = answers.sort{|a,b| declarative_index(a) <=> declarative_index(b)}
        sorted_answers.any? && sorted_answers.first.split.join(' ') || ""
      end
    end

    def answers
      answers = (Parser::Google.new(sentence).all_answers + [Parser::Evi.new(sentence).answer]).compact
    end

    def declarative_index(phrase)
      return 500 if phrase.include?("?")
      (phrase =~ ::Grammar::LanguageHelper::DECLARATIVE_DETECTOR) || 1000
    end

    def sentence
      @sentence ||= message.trigger.downcase.gsub("alice", "").gsub(",", "").strip
    end

  end
end
