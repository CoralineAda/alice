require 'nokogiri'

module Parser
  class Google

    attr_accessor :question
    attr_reader :answer

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
      answers.reject!{|a| a.include?("...")}
      best_answer = answers.sort{|a,b| declarative_index(a) <=> declarative_index(b)}.first.split.join(' ')
      Alice::Util::Logger.info "*** Parser::Google: Answered \"#{self.question}\" with #{best_answer}"
      return best_answer
    rescue Exception => e
      Alice::Util::Logger.info "*** Parser::Google: Unable to process \"#{self.question}\": #{e}"
      Alice::Util::Logger.info e.backtrace
      ""
    end

    def declarative_index(answer)
      answer =~ Grammer::LanguageHelper::DECLARATIVE_DETECTOR || 1000
    end

  end
end
