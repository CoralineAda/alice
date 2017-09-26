require "google/cloud/language"

module Grammar
  class SentenceParser

    attr_reader :sentence, :tokens

    def self.parse(sentence)
      new(sentence).parse
    end

    def self.declarative_index(sentence)
      new(sentence).parse.declarative_index
    end

    def initialize(sentence)
      @sentence = sentence
    end

    def parse
      language = Google::Cloud::Language.new
      document = language.document(self.sentence)
      @tokens = document.syntax.tokens
      self
    end

    def contains_possessive
      tokens.find{|token| token.label == :POSS}
    end

    def remove(what)
      return self if what.nil?
      regexp = Regexp.new(what.to_s + "(?:'s)?", 'i')
      result = tokens.reject!{|e| regexp.match(e.text) }
      result
    end

    def adjectives
      tokens.select{|token| token.part_of_speech.tag == :ADJ}.map(&:text)
    end

    def adverbs
      tokens.select{|token| token.part_of_speech.tag == :ADVMOD}.map(&:text)
    end

    def declarative_index
      return 500 if sentence.include?("?")
      words.inject([]) do |scores, word|
        pr = pronouns.include?(word) && words.index(word) + 2 * 2 || 100
        iv = Grammar::LanguageHelper::INFO_VERBS.include?(word) && words.index(word) + 1 * 1.1 || 100
        be = declarative_verbs.any? && words.index(word) || 100
        scores << [pr, iv, be].min
      end
    end

    def declarative_verbs
      tokens.select{|token| token.part_of_speech.tag == :VERB && token.lemma == "be"}.map(&:text)
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
      tokens.select{|token| token.part_of_speech.tag == :PRON}.map(&:text)
    end

    def verbs
      @verbs ||= tokens.select{|token| token.part_of_speech.tag == :VERB}.map(&:text)
    end

    def words
      @words ||= sentence.split(" ")
    end

  end
end
