require 'nokogiri'

module Parser
  class Google

    attr_accessor :question

    def self.fetch(topic)
      new(topic).sorted_answers.first
    end

    def self.fetch_all(topic)
      new(topic).sorted_answers
    end

    def initialize(question)
      @question = question.gsub("+", "plus").gsub(" ", "+").encode("ASCII", invalid: :replace, undef: :replace, replace: '')
    end

    def sorted_answers
      answers = sanitized_answers(full_search + reductivist_search)
      Grammar::DeclarativeSorter.sort(query: question, corpus: answers)
    end

    private

    def sanitized_answers(answer_array)
      answer_array.map do |answer|
        answer = answer.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
        answer.delete!("\n")
        if answer.include?("...")
          answer = answer.split("...").select{ |c| c =~ /\.$/ }.first.to_s
        end
        answer = answer.gsub(/^ /,'')
      end.compact.uniq#.reject{ |a| a =~ /\.\.\./}
    end

    def full_search
      search(question)
    end

    def reductivist_search
      parsed_question = Grammar::SentenceParser.parse(question)
      query = "wikipedia what is #{(parsed_question.nouns + parsed_question.adjectives).join(' ')}"
      search(query)
    end

    def search(query)
      doc = Nokogiri::HTML(open("https://www.google.com/search?q=#{query}&hl=lang_en"))
      doc.css("div span.st").map(&:text)
    rescue Exception => e
      Alice::Util::Logger.info "*** Parser::Google: Unable to process \"#{self.question}\": #{e}"
      Alice::Util::Logger.info e.backtrace
      return ["Hmm, I can't really answer that since Google is getting suspicious of me. You should probably rotate my IP address again."]
    end

  end
end
