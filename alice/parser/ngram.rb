module Parser

  class Ngram

    include Parser::LanguageHelper

    attr_accessor :contents

    def initialize(grams=[])
      self.contents = grams
    end

    def omnigrams
      self.contents.map{|gram| gram.is_a?(Array) && gram.flatten || nil}.compact
    end

    def with_leading(matches, args={})
      phrase_matches = omnigrams.reject{|h| h.flatten.is_a? String}.inject([]) { |a, gram| a << gram if ([gram.flatten[0]] & matches).present?; a}
      matches = Search::Ngram.new((phrase_matches).compact.select(&:present?).uniq)
      matches = matches.minus(IDENTIFIERS) if args[:object_only]
      matches = matches.to_a.flatten.uniq if args[:flatten]
      matches
    end

    def with(matches)
      phrase_matches = omnigrams.select{|h| h.flatten.is_a? Array}.inject([]) { |a, gram| a << gram if (gram.flatten & matches).present?; a}
      Search::Ngram.new((phrase_matches).compact.select(&:present?).uniq)
    end

    def without(matches)
      phrase_matches = omnigrams.select{|h| h.flatten.is_a? Array}.inject([]) { |a, gram| a << gram if (gram.flatten & matches).empty?; a}
      Search::Ngram.new((phrase_matches).compact.select(&:present?).uniq)
    end

    def minus(matches)
      with(matches).to_a.map{|gram| gram - matches}.compact.select(&:present?).uniq
    end

    def to_a
      self.contents
    end

  end

end
