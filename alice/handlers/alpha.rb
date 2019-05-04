module Handlers
  class Alpha

    include PoroPlus
    include Behavior::HandlesCommands

    def answer_question
      message.response = answer || Util::Randomizer.i_dont_know
    end

    private

    def answer
      # Try Wolfram Alpha first, then fall back to Google
      if results = Parser::Alpha.new(sentence).answer
        results.first
      elsif answers.any?
        Parser::Google.fetch(sentence)
      end
    end

    def sentence
      @sentence ||= message.trigger.downcase.gsub(/#{ENV['BOT_NAME']}/i, "").gsub(",", "").strip
    end

  end
end
