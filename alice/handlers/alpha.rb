module Handlers
  class Alpha

    include PoroPlus
    include Behavior::HandlesCommands

    def answer_question
      message.set_response(answer || Util::Randomizer.i_dont_know)
    end

    private

    def answer
      Alice::Util::Logger.info "sentence = #{sentence}"
      Parser::Alpha.new(sentence).answer || Parser::Google.new(sentence).answer
    end

    def sentence
      @sentence ||= command_string.sentence.downcase.gsub("alice", "")
    end

  end
end
