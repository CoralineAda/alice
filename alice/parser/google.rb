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
      html = Nokogiri::HTML(open("https://www.google.com/search?q=#{question}"))
      html.css('span.st').first.inner_text
    end

  end
end
