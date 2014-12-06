module Alice

  module Parser

    module LanguageHelper

      ARTICLES = %w{a the of an to and}

      INFO_VERBS = [
        "delete",
        "describe",
        "does",
        "examine",
        "hear",
        "heard",
        "hearing",
        "hid",
        "inspect",
        "is",
        "are",
        "know",
        "look",
        "set",
        "tell",
        "think",
        "was"
      ]

      RELATION_VERBS = [
        "made",
        "make",
        "makes",
        "has",
        "have",
        "holds"
      ]

      GREETINGS = %w{hi hello evening morning hii hiii hiiii guten ohai hai ahoy yo heya}

      ACTION_VERBS = [
        "say",
        "greet",
        "welcome",
        "thank",
        "thanks",
        "do"
      ]

      ADVERBS = [
        "lately",
        "recently"
      ]

      INTERROGATIVES = [
        "how",
        "what",
        "when",
        "where",
        "who"
      ]

      NUMBERS = {
        'one' => '1',
        'two' => '2',
        'three' => '3',
        'four' => '4',
        'five' => '5',
        'six' => '6',
        'seven' => '7',
        'eight' => '8',
        'nine' => '9',
        'ten' => '10'
      }

      PREPOSITIONS = [
        "about",
        "at",
        "by",
        "for",
        "from",
        "in",
        "into",
        "of",
        "on",
        "onto",
        "to",
        "toward",
        "towards",
        "with",
        "within",
        "without"
      ]

      TRANSFER_VERBS = [
        "donate",
        "drop",
        "gave",
        "get",
        "give",
        "hand",
        "pass",
        "pick",
        "take"
      ]

      VERBS = TRANSFER_VERBS + INFO_VERBS + ACTION_VERBS + RELATION_VERBS

      NOUN_INDICATORS = %w{ the a an this about }

      IDENTIFIERS = NUMBERS.keys + NUMBERS.values + ARTICLES

      PREDICATE_INDICATORS = PREPOSITIONS + NOUN_INDICATORS + INFO_VERBS + ACTION_VERBS + TRANSFER_VERBS + RELATION_VERBS

      PRONOUNS = %w{ him her his him hers they theirs them he she it its this those these that }

      def self.similar_to(original_word, test_word)
        return true if original_word =~ /#{test_word}/i
        return true if test_word =~ /#{original_word}/i
        RubyFish::Hamming.distance(original_word, test_word) <= 5
      end

    end

  end

end
