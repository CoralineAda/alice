module Handlers
  class Alpha

    include PoroPlus
    include Behavior::HandlesCommands

    def answer_question
      message.set_response(answer || Util::Randomizer.i_dont_know)
    end

    private

    def answer
      @answer = Parser::Alpha.new(command_string.sentence.gsub(/alice/i,"")).answer
      @answer = Parser::Google.new(command_string.sentence).answer if @answer.nil?
    end

  end
end
