require 'nokogiri'

module Parser
  class Google

    attr_accessor :question

    def self.fetch(topic)
      new(topic).answer
    end

    def self.fetch_all(topic)
      new(topic).all_answers
    end

    def initialize(question)
      @question = question.gsub("+", "plus").gsub(" ", "+")
    end

    def answer
      results
    end

    def all_answers
      answers = full_search + reductivist_search
      answers.reject!{|a| a =~ /\.\.\.$/}
      answers.reject!{|a| a.empty? }
      answers
    end

    private

    def results
      answers = full_search + reductivist_search
      answers.reject!{|a| a =~ /\.\.\.$/}
      answers.reject!{|a| a.empty? }
      sorted_answers = answers.sort{|a,b| declarative_index(a) <=> declarative_index(b)}
      best_answer = sorted_answers.any? && sorted_answers.first.split.join(' ') || ""
      Alice::Util::Logger.info "*** Parser::Evi: Answered \"#{self.question}\" with #{best_answer}"
      return best_answer
    rescue Exception => e
      Alice::Util::Logger.info "*** Parser::Evi: Unable to process \"#{self.question}\": #{e}"
      Alice::Util::Logger.info e.backtrace
      ""
    end

    def full_search
      doc = Nokogiri::HTML(open("https://www.google.com/search?q=#{question}"))
      responses = doc.css("div span.st").map(&:text)
      results = []
      responses.each do |response|
        if response =~ /\.\.\./
          response = response.split("...")[1..-1].join(' ')
        end
        results << response.strip
      end
      results.compact
    end

    def reductivist_search
      doc = Nokogiri::HTML(open("https://www.google.com/search?q=#{simplified_question}"))
      responses = doc.css("div span.st").map(&:text)
      results = []
      responses.each do |response|
        if response =~ /\.\.\./
          response = response.split("...")[1..-1].join(' ')
        end
        results << response.strip
      end
      results.compact
    end

    def simplified_question
      parsed_question = Grammar::SentenceParser.parse(question)
      (parsed_question.nouns + parsed_question.adjectives).join(' ')
    end

    def declarative_index(answer)
      (answer =~ ::Grammar::LanguageHelper::DECLARATIVE_DETECTOR) || 1000
    end

  end
end
