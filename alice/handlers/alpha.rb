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
        result.first
      else
        return nil unless answers.any?
        answers_with_indices = answers.map do |answer|
          {
            index: ::Grammar::SentenceParser.declarative_index(answer) + answers.index(answer),
            answer: answer
          }
        end
        answers_with_indices.sort{ |a,b| a[:index] <=> b[:index] }.first[:answer]
      end
    end

    def answers
      @answers ||= Parser::Google.new(sentence).all_answers.map do |answer|
        if answer.include?("...")
          answer.split("...")[1] || nil
        else
          answer
        end
      end.compact
    end

    def sentence
      @sentence ||= message.trigger.downcase.gsub(/#{ENV[BOT_NAME]}/i, "").gsub(",", "").strip
    end

  end
end
