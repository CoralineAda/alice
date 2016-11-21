module Handlers
  class Alpha

    include PoroPlus
    include Behavior::HandlesCommands

    def answer_question
      message.set_response(answer || Util::Randomizer.i_dont_know)
    end

    private

    def answer
      Parser::Alpha.new(sentence).answer || Parser::Google.new(sentence).answer
    end

    def sentence
      @sentence ||= command_string.sentence.gsub(/alice/i, "")
    end

  end
end
