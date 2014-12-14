module Handlers
  class Alpha

    include PoroPlus
    include Behavior::HandlesCommands

    def answer_question
      message.set_response(answer || Util::Randomizer.i_dont_know)
    end

    private

    def answer
      @answer ||= Parser::Alpha.new(command_string.sentence).answer
    end

  end
end
