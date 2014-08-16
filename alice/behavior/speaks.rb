module Alice

  module Behavior

    module Speaks

      def dictionary
        @dictionary ||= MarkyMarkov::TemporaryDictionary.new
      end

      def prepare
        corpus =  ::Factoid.all.map(&:formatted)
        corpus << ::OH.all.map(&:text)
        corpus << ::Bio.all.map(&:formatted)
        @prepared = corpus.flatten.map{|sentence| dictionary.parse_string(sentence)}
      end

      def generated_message
        prepare && dictionary.generate_1_sentence(3)
      end

      def random_message
        return unless Alice::Util::Randomizer.one_chance_in(2)
        self.catchphrases.sample.text
      end

      def speak
        random_message || generated_message
      end

    end

  end

end
