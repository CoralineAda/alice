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
      Alice::Util::Logger.info "*** sentence = #{sentence}"
      if results = Parser::Alpha.new(sentence).answer
        results.first
      else
        Parser::Google.fetch(sentence)
      end
    end

    def sentence
      @sentence ||= message.trigger.downcase.gsub(/#{ENV['BOT_NAME']}/i, "").gsub(/\<\@#{::User.bot.slack_id}\>/i, "").gsub(",", "").strip
    end

  end
end
