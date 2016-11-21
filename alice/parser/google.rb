require 'nokogiri'

module Parser
  class Google

    attr_accessor :question
    attr_reader :answer

    def initialize(question)
      @question = question.gsub(/[^[:alpha:] 0-9]/,'').gsub(/alice/i, "").gsub(" ", "+")
    end

    def answer
      results
    end

    private

    def results
      doc = Nokogiri::HTML(open("https://www.google.com/search?q=#{question}"))
      result = doc.css("div span.st").map(&:inner_html).sort{|a,b| a.length <=> b.length}.last
    end

  end
end
