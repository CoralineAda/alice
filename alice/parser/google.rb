require 'nokogiri'

module Parser
  class Google

    attr_accessor :question
    attr_reader :answer

    DECLARATIVE_DETECTOR = /\b#{Grammar::LanguageHelper::INFO_VERBS * '|\b'}/ix

    def initialize(question)
      @question = question.gsub("+", "plus").gsub(" ", "+")
    end

    def answer
      results
    end

    private

    def results
      doc = Nokogiri::HTML(open("https://www.google.com/search?q=#{question}"))
      answers = doc.css("div span.st").map(&:text)
      answers.sort{|a,b| declarative_index(a) <=> declarative_index(b)}.first
      Alice::Util::Logger.info "*** Parser::Google: Answered \"#{self.question}\" with #{answer}"
      return answer.split.join(' ')
    rescue Exception => e
      Alice::Util::Logger.info "*** Parser::Google: Unable to process \"#{self.question}\": #{e}"
      Alice::Util::Logger.info e.backtrace
      ""
    end

    def declarative_index(answer)
      answer =~ DECLARATIVE_DETECTOR || 1000
    end

  end
end
