module Parser
  class Wikipedia
    def self.fetch(topic)
      if result = Wikipedia.find(topic)
        content = result.sanitized_content
      end
    end
  end
end