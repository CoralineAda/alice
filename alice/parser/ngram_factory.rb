module Alice

  module Parser

    class NgramFactory

      attr_accessor :options, :target
     
      def self.filtered_grams_from(words)
        filtered = words.split.reject!{|name| Alice::Parser::LanguageHelper::IDENTIFIERS.include?(name)}
        filtered.reject!(&:empty?)
        new(filtered.join(' ')).omnigrams
      end

      def self.omnigrams_from(words)
        words = words.downcase.split(/[^a-zA-Z0-9\_\-]/).uniq
        words << words.map{|word| Lingua.stemmer(word.downcase)}
        new(words).omnigrams.to_a.flatten.uniq.reject!(&:empty?)
      end

      def initialize(target)
        @target = target
      end

      def omnigram(args={})
        exclude = [args[:exclude]].flatten.compact
        uni = ngrams(1).reject{|unigram| (exclude & unigram.flatten).count > 0}
        bi  = ngrams(2).reject{|unigram| (exclude & unigram.flatten).count > 0} 
        tri = ngrams(3).reject{|unigram| (exclude & unigram.flatten).count > 0} 
        Alice::Parser::Ngram.new(uni + bi + tri)
      end

      def omnigrams
        omnigram.omnigrams
      end

      private

      def unigrams
        Alice::Parser::Ngram.new(ngrams(1))
      end
     
      def bigrams
        Alice::Parser::Ngram.new(ngrams(2))
      end
     
      def trigrams
        Alice::Parser::Ngram.new(ngrams(3))
      end

     def ngrams(n)
        self.target.split.each_cons(n).to_a
      end

    end

  end

end
