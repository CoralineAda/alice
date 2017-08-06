module Grammar
  module LanguageHelper

    ARTICLES = %w{a the of an to and}

    INFO_VERBS = [
      "are",
      "created",
      "delete",
      "describe",
      "did",
      "examine",
      "had",
      "has",
      "hear",
      "heard",
      "hearing",
      "hid",
      "inspect",
      "is",
      "know",
      "look",
      "made",
      "set",
      "tell",
      "think",
      "was",
      "wrote",
      "do",
      "does",
      "were"
    ]

    RELATION_VERBS = [
      "made",
      "make",
      "makes",
      "has",
      "have",
      "holds"
    ]

    GREETINGS = %w{hi hello good+evening good+morning good+night good+afternoon hii hiii hiiii guten ohai hai ahoy yo heya}

    ACTION_VERBS = [
      "say",
      "greet",
      "welcome",
      "thank",
      "thanks",
      "love",
      "do"
    ]

    ADVERBS = [
      "lately",
      "recently"
    ]

    CONJUNCTIONS = [
      "accordingly",
      "after",
      "also",
      "although",
      "and",
      "assuming",
      "because",
      "before",
      "besides",
      "but",
      "consequently",
      "conversely",
      "even",
      "for",
      "furthermore",
      "hence",
      "how",
      "however",
      "if",
      "instead",
      "lest",
      "likewise",
      "meanwhile",
      "moreover",
      "nevertheless",
      "nonetheless",
      "nor",
      "now",
      "once",
      "or",
      "otherwise",
      "provided",
      "rather",
      "since",
      "so that",
      "so",
      "still",
      "than",
      "that",
      "then",
      "therefore",
      "though",
      "thus",
      "till",
      "unless",
      "until",
      "what",
      "whatever",
      "when",
      "whenever",
      "whereas",
      "whether",
      "which",
      "whichever",
      "while",
      "why",
      "yet",
      "wherever"
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

    DECLARATIVE_DETECTOR = /\b#{INFO_VERBS * '|\b'}/ix

    NOUN_INDICATORS = %w{ the a an this about }

    IDENTIFIERS = NUMBERS.keys + NUMBERS.values + ARTICLES

    PREDICATE_INDICATORS = PREPOSITIONS + NOUN_INDICATORS + INFO_VERBS + ACTION_VERBS + TRANSFER_VERBS + RELATION_VERBS

    PRONOUNS = %w{ him her his him hers they their their them he she its this those these that }

    WORDS_WITH_PERIODS = ["dr.", "mr.", "ms.", "phd.", "mrs."]

    def self.similar_to(original_word, test_word)
      return true if original_word =~ /#{test_word}/i
      return true if test_word =~ /#{original_word}/i
      RubyFish::Hamming.distance(original_word, test_word) <= 5
    end

    def self.sentences_from(text)
      return [] unless text
      text = text.gsub(/(#{WORDS_WITH_PERIODS * '|'})/i, '\1@@@')
      text = text.split(/[\.\?\!] /)
      text = text.map{|t| t.split(/[\r\n]/)}.flatten
      text = text.map{|t| t.gsub('@@@', '')}
    end

    def self.to_third_person(text)
      text.gsub(/\wI\w/, "they")
          .gsub(/\wam\w/, "are")
          .gsub(/\whave\w/, "has")
          .gsub(/\wmy\w/, "their ")
    end

  end
end
