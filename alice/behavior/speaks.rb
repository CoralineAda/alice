require 'wikipedia'

module Behavior

  module Speaks

    def dictionary
      return @dictionary if @dictionary
      @dictionary ||= MarkyMarkov::TemporaryDictionary.new
      @dictionary.parse_file('./db/corpus/seeds.txt')
      @dictionary
    end

    def prepare
      return @prepared if @prepared
      @prepared = corpus.map{|sentence| dictionary.parse_string(sentence)}
      @prepared
    end

    def corpus
      return @corpus if @corpus
      @corpus =  ::Factoid.all.map(&:formatted)
      @corpus << ::OH.all.map(&:text)
      @corpus << Grammar::LanguageHelper.sentences_from(seed_text)
      @corpus = @corpus.flatten
      @corpus
    end

    def converse
      context = Context.current
      context ||= Context.find_or_create(seed_word)
      context ||= Context.all.sample
      context.describe
    end

    def seed_text
      ::Sanitize.fragment(Wikipedia.find(seed_word).sanitized_content)
    end

    def seed_word
      seed_word = dictionary.dictionary.keys.flatten.select{|w| w.size > 6}
      seed_word = seed_word.reject{|w| w =~ /[er|ly|ed|ing]$/ }
      seed_word.sample || "Cryptography"
    end

    def generated_message
      prepare && dictionary.generate_1_sentence
    end

    def random_message
      self.catchphrases.present? && self.catchphrases.sample.text || speak
    end

    def speak
      case rand(5)
      when 0; random_message
      when 1; generated_message
      when 2..4; converse
      end
    end

  end

end
