module Parser
  class Wikipedia

    attr_reader :topic

    def self.fetch(topic)
      new(topic).answer
    end

    def self.fetch_all(topic)
      new(topic).results
    end

    def initialize(topic)
      @topic = topic
    end

    def answer
      results.sample
    end

    def results
      if result = ::Wikipedia.find(topic)
        content = Grammar::LanguageHelper.sentences_from(result.sanitized_content)
      else
        content = []
      end
      content[0..10]
    end

  end
end
