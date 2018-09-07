module Grammar
  class DeclarativeSorter

    attr_reader :query, :corpus

    def self.sort(query: "", corpus: [])
      new(query: query, corpus: corpus).sorted_corpus
    end

    def initialize(query: "", corpus: [])
      @query = query
      @corpus = corpus
    end

    def sorted_corpus
      corpus.sort do |a,b|
        (declarative_index_for(a) + keyword_density(a)) <=> (declarative_index_for(b) + keyword_density(b))
      end.reverse
    end

    private

    def declarative_index_for(sentence)
      index = corpus.index(sentence)
      parsed_sentence = parsed_sentences[index]
      words = sentence.split

      return 0 if sentence.include?("?")
      pronoun_index = parsed_sentence.pronouns.map{ |pronoun| words.index(pronoun) || 100}.min.to_i
      info_verb_index = parsed_sentence.info_verbs.map{ |verb| words.index(verb) || 100 }.min.to_i
      declarative_verb_index = parsed_sentence.declarative_verbs.map{ |verb| words.index(verb) || 100 }.min.to_i
      if pronoun_index < 3 && info_verb_index < 3
        declarative_index = pronoun_index + info_verb_index
      elsif pronoun_index < 3 && declarative_verb_index < 3
        declarative_index = pronoun_index + declarative_verb_index
      elsif declarative_verb_index == 100
        declarative_index = info_verb_index + 1 * 1.1
      end
      declarative_index ||= [pronoun_index + 2 * 2, info_verb_index + 1 * 1.1, declarative_verb_index].min
      return 100 - declarative_index
    end

    def weighted_keywords
      return @weighted_keywords if defined? @weighted_keywords
      @weighted_keywords ||= {}

      parsed_sentences.each do |sentence|
        words = sentence.nouns + sentence.objects + sentence.adjectives
        words.each do |word|
          @weighted_keywords[word.downcase] ||= 0
          @weighted_keywords[word.downcase] += 1
        end
      end

      (parsed_query.nouns + parsed_query.objects).each do |word|
        @weighted_keywords[word.downcase] ||= 0
        @weighted_keywords[word.downcase] += 5
      end

      parsed_query.adjectives.each do |word|
        @weighted_keywords[word.downcase] ||= 0
        @weighted_keywords[word.downcase] += 3
      end

      Hash[@weighted_keywords.sort{|a,b| a[1] <=> b[1]}].select{|k,v| v > 1}
    end

    def keyword_density(sentence)
      words = sentence.split
      keywords_present = weighted_keywords.keys & words
      keywords_present.reduce(0) { |weight,keyword| weight + weighted_keywords[keyword] + (words.length - words.index(keyword)) }
    end

    def parsed_query
      @parsed_query ||= Grammar::SentenceParser.new(self.query).parse
    end

    def parsed_sentences
      @parsed_sentences ||= corpus.map{ |sentence| Grammar::SentenceParser.new(sentence).parse }
    end

    def adjectives
      tokens.select{|token| token.part_of_speech.tag == :ADJ}.map(&:text)
    end

    def adverbs
      tokens.select{|token| token.part_of_speech.tag == :ADVMOD}.map(&:text)
    end

    def declarative_verbs
      @declarative_verbs ||= tokens.select{|token| token.part_of_speech.tag == :VERB && token.lemma == "be"}.map(&:text)
    end

    def info_verbs
      @info_verbs ||= words.select{|word| Grammar::LanguageHelper::INFO_VERBS.include?(word)}
    end

    def interrogatives
      tokens.select{|token| Grammar::LanguageHelper::INTERROGATIVES.include? token}.map(&:text)
    end

    def nominative_pronouns
      tokens.select{|token| token.part_of_speech.tag == :PRON && token.part_of_speech.case == :NOMINATIVE || token.part_of_speech.case == :GENITIVE}.map(&:text)
    end

    def nouns
      tokens.select{|token| token.part_of_speech.tag == :NOUN || token.label == :ATTR || token.label == :POBJ || token.part_of_speech.tag == :X}.map(&:text)
    end

    def objects
      tokens.select{|token| token.part_of_speech.tag == :NOUN && token.label == :DOBJ}.map(&:text)
    end

    def prepositions
      tokens.select{|token| token.label == :PREP}.map(&:text)
    end

    def pronouns
      @pronouns ||= tokens.select{|token| token.part_of_speech.tag == :PRON}.map(&:text)
    end

    def verbs
      @verbs ||= tokens.select{|token| token.part_of_speech.tag == :VERB}.map(&:text)
    end

  end
end
