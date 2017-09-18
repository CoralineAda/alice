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
      return [] unless result = ::Wikipedia.find(topic)
      content = Grammar::LanguageHelper.sentences_from(result.sanitized_content).compact
      content = content.map{|datum| datum.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '') }
      return content[0..20]
    end

  end
end
