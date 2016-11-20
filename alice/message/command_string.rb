module Message

  class CommandString

    attr_accessor :content

    def initialize(content)
      self.content = content
    end

    def components
      @components ||= self.content.split(' ').reject{|w| w.blank? }.map do |c|
        c.gsub(/\'s/, ' for').gsub(/^\!/,'').gsub(/\+/, '').gsub(/[\?\!\.\,]$/, '')
      end
    end

    def probable_nouns
      re = Regexp.union(Grammar::LanguageHelper::PREDICATE_INDICATORS.map{|w| /\s*\b#{Regexp.escape(w)}\b\s*/i})
      candidates = self.content.split(re).map(&:split).compact.flatten.map{|word| word.gsub(/[\.\?\!]?$/, '')}
      remove_markers(candidates)
    end

    def remove_markers(list)
      list = list - [ "you", "your", "Alice", "Alice," ]
      list = list - Grammar::LanguageHelper::PRONOUNS
      list = list - Grammar::LanguageHelper::VERBS
      list = list - Grammar::LanguageHelper::INTERROGATIVES
      list = list - Grammar::LanguageHelper::NOUN_INDICATORS
      list
    end

    def sentence
      "#{subject} #{predicate}"
    end

    def has_predicate?
      predicate_position > 0
    end

    def predicate
      return unless predicate_positions.max
      candidates = components[(predicate_positions.max + 1)..-1]
      candidates = remove_markers(candidates)
      candidates.join(' ').gsub(/[\.\,\?\!]+$/, '')
    end

    def predicate_positions
      Grammar::LanguageHelper::PREDICATE_INDICATORS.map{ |indicator| components.index(indicator) }.compact
    end

    def predicate_position
      predicate_positions.max || 0
    end

    def quoted_text
      return unless content =~ /"/
      return "" if content =~ /""/
      content.gsub(/.*"(.*)".*/, '\1')
    end

    def raw_command
      self.content.gsub(/^.?#{verb} /, "")
    end

    def subject
      return components[0..(predicate_position - 1)].join(' ').gsub(/[\.\,\?\'\!]+$/, '').gsub("++", "")
    end

    def fragment
      (components - [verb]).join(' ')
    end

    def verb
      components[0].to_s.gsub(/^!/, '')
    end

  end
end
