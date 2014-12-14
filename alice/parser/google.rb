module Parser
  class Google
    def self.fetch(topic)
      if results = RubyWebSearch::Google.search(query: topic).results
        content = results[0..2].map do |result|
          begin
            Parser::URL.new(result[:url]).content
          rescue
            ""
          end
        end.flatten.join(' ')
      end
    end
  end
end