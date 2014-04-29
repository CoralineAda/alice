module Alice

  module Behavior

    module Speaks

      def speak
        prepare && dictionary.generate_1_sentence(3)
      end

      def dictionary
        @dictionary ||= MarkyMarkov::TemporaryDictionary.new
      end

      def prepare
        corpus = Alice::Factoid.all.map(&:formatted)
        corpus << Alice::Oh.all.map(&:formatted)
        corpus << Alice::Bio.all.map(&:formatted)
        @prepared = corpus.flatten.map{|sentence| dictionary.parse_string(sentence)}
      end

    end

  end

end