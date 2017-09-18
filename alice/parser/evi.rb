require 'nokogiri'

module Parser
  class Evi

    attr_accessor :question

    def self.fetch(topic)
      new(topic).answer
    end

    def initialize(question)
      @question = question.downcase.gsub(" ", "_").encode("ASCII", invalid: :replace, undef: :replace, replace: '')
    end

    def answer
      results
    end

    private

    def results
      doc = Nokogiri::HTML(open("https://www.evi.com/q/#{self.question}"))
      answer = doc.css("div.tk_common").map(&:text).first
      return "" if answer.nil? || answer.include?("don't yet have an answer")
      Alice::Util::Logger.info "*** Parser::Evi: Answered \"#{self.question}\" with #{answer.strip}"
      return answer.strip
    rescue Exception => e
      Alice::Util::Logger.info "*** Parser::Evi: Unable to process \"#{self.question}\": #{e}"
      Alice::Util::Logger.info e.backtrace
      ""
    end

  end
end
