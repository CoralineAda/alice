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
      result.sample
    end

    private

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
