module Parser
  class Wikipedia

    attr_reader :topic

    def self.fetch(topic)
      new(topic).answer
    end

    def initialize(topic)
      @topic = topic
    end

    def answer
      if result = ::Wikipedia.find(topic)
        content = result.sanitized_content
        Grammar::LanguageHelper.sentences_from.each do |sentence|
      end

    end

    private

    def store_facts
      results.each do |result|
        Factoid.create(text: result) if 
      end
    end

    def results
      if result = ::Wikipedia.find(topic)
        content = Grammar::LanguageHelper.sentences_from(result.sanitized_content)
      else
        content = []
      end
      content
    end

  end
end
