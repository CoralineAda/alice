module Handlers
  class Alpha

    include PoroPlus
    include Behavior::HandlesCommands

    def answer_question
      message.response = answer || Util::Randomizer.i_dont_know
    end

    private

    def answer
      if results = Parser::Alpha.new(sentence).answer
        results.first
      elsif answers.any?
        Grammar::DeclarativeSorter.sort(query: sentence, corpus: answers).first
      end
    end

    def answers
      @answers ||= Parser::Google.new(sentence).all_answers.map do |answer|
        if answer.include?("...")
          answer = answer.split("...")[1] || ""
        end
        if answer.scan(/\. [a-zA-Z]+/).any?
          answer.split('.')[0..-2].join(' ')
        else
          answer
        end
      end.compact
    end

    def sentence
      @sentence ||= message.trigger.downcase.gsub(/#{ENV['BOT_NAME']}/i, "").gsub(",", "").strip
    end

  end
end
