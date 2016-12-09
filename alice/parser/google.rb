require 'nokogiri'

module Parser
  class Google

    attr_accessor :question

    def self.fetch(topic)
      new(topic).answer
    end

    def initialize(question)
      @question = question.gsub("+", "plus").gsub(" ", "+")
    end

    def answer
      results
    end

    def all_answers
      answers = full_search + reductivist_search
      answers.reject!{|a| a.include?("...")}
      answers
    end

    private

    def results
      answers = full_search + reductivist_search
      answers.reject!{|a| a.include?("...")}
      sorted_answers = answers.sort{|a,b| declarative_index(a) <=> declarative_index(b)}
      best_answer = sorted_answers.any? && sorted_answers.first.split.join(' ') || ""
      Alice::Util::Logger.info "*** Parser::Google: Answered \"#{self.question}\" with #{best_answer}"
      return best_answer
    rescue Exception => e
      Alice::Util::Logger.info "*** Parser::Google: Unable to process \"#{self.question}\": #{e}"
      Alice::Util::Logger.info e.backtrace
      ""
    end

    def full_search
      doc = Nokogiri::HTML(open("https://www.google.com/search?q=#{question}"))
      doc.css("div span.st").map(&:text)
    end

    def reductivist_search
      doc = Nokogiri::HTML(open("https://www.google.com/search?q=#{simplified_question}"))
      doc.css("div span.st").map(&:text)
    end

    def simplified_question
      Grammar::LanguageHelper.probable_nouns_from(question)
    end

    def declarative_index(answer)
      (answer =~ ::Grammar::LanguageHelper::DECLARATIVE_DETECTOR) || 1000
    end

  end
end
