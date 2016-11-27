require 'timeout'

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
      Timeout::timeout(10) do
        answer = Parser::Alpha.new(sentence).answer
      end
    rescue Timeout::Error
      answer = Parser::Google.new(sentence).answer
    ensure
      answer
    end

    def sentence
      @sentence ||= message.trigger.downcase.gsub("alice", "").gsub(",", "").strip
    end

  end
end
