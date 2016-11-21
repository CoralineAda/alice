require 'nokogiri'

module Parser
  class Google

    attr_accessor :question
    attr_reader :answer

    def initialize(question)
      @question = question.gsub(" ", "+")
    end

    def answer
      results
    end

    private

    def results
      doc = Nokogiri::HTML(open("https://www.google.com/search?q=#{question}"))
      answer = doc.css("div span.st").map(&:text).sort{|a,b| a.length <=> b.length}.last
      Alice::Util::Logger.info "*** Parser::Alpha: Answered \"#{self.question}\" with #{answer}"
      return answer
    rescue Exception => e
      Alice::Util::Logger.info "*** Parser::Google: Unable to process \"#{self.question}\": #{e}"
      Alice::Util::Logger.info e.backtrace
      ""
    end

  end
end
