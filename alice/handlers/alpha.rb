module Handlers
  class Alpha

    include PoroPlus
    include Behavior::HandlesCommands

    def answer_question
      message.set_response(answer || Util::Randomizer.i_dont_know)
    end

    private

    def answer
      sorted_answers = answers.sort{|a,b| declarative_index(a) <=> declarative_index(b)}
      sorted_answers.any? && sorted_answers.first.split.join(' ') || ""
    end

    def answers
      answers = ([Parser::Alpha.new(sentence).answer] + Parser::Google.new(sentence).all_answers + [Parser::Evi.new(sentence).answer]).compact
    end

    def answer_old
      Alice::Util::Logger.info "sentence = #{sentence}"
      Parser::Alpha.new(sentence).answer || Parser::Google.new(sentence).answer
    end

    def declarative_index(phrase)
      (phrase =~ ::Grammar::LanguageHelper::DECLARATIVE_DETECTOR) || 1000
    end

    def sentence
      @sentence ||= message.trigger.downcase.gsub("alice", "").gsub(",", "").strip
    end

  end
end
