module IsA
  class Parser

    attr_reader :text

    def self.answer(question)
      new(question).response
    end

    def self.parse(statement)
      new(statement).parse
    end

    def initialize(text)
      @text = text.downcase.gsub(/\(.*?\)/,'')
    end

    def parse
      return unless subject
      characteristics.each do |characteristic|
        this_characteristic = IsA::Characteristic.find_or_create_by(name: characteristic)
        subject.has!(this_characteristic)
      end
      definitions.each do |definition|
        this_definition = IsA::Category.find_or_create_by(name: definition)
        subject.is!(this_definition)
      end
    end

    def response
#      reponse_text = set_characteristic if is_characteristic_definition?
      reponse_text ||= characteristic_answer if is_characteristic_question?
#      reponse_text ||= set_category if is_category_definition?
      reponse_text ||= category_answer if is_category_question?
      reponse_text
    end

    private

    def category
      if is_question?
        Category.where(name: singularized_nouns.last).last || Category.new(name: nouns.last)
      else
        Category.find_or_create_by(name: singularized_nouns.last)
      end
    end

    def category_answer
      return "I don't know what #{subject.name} means." unless subject.connected?
      return "No, but they are both #{category.shared_parent(subject).plural_name}." if category.is_sibling?(subject)
      return "Yes." if subject.is?(category)
      return "#{subject.plural_name} can sometimes be #{category.plural_name}." if category.has?(subject)
      return "I don't know anything about #{category.plural_name}." unless category.children.any?
      return "Some #{subject.plural_name} are #{category.plural_name}." if subject.has?(category)
      "I don't think so."
    end

    def characteristics
      sentence.tokens.select{ |token| token.label == :AMOD }.map(&:lemma)
      # if is_question?
      #   Characteristic.where(name: singularized_nouns.last).last || Characteristic.new(name: nouns.last)
      # else
      #   Characteristic.find_or_create_by(name: singularized_nouns.last)
      # end
    end

    def definitions
      sentence.tokens.select{ |token| token.label == :ATTR }.map(&:lemma)
    end

    def characteristic_answer
      return "Yes." if subject.has?(characteristic)
      return "#{subject.name.pluralize.capitalize} sometimes do." if subject.any_child_has?(characteristic)
      return "It might." if subject.any_parent_has?(characteristic)
      "Not as far as I know."
    end

    def is_characteristic_question?
      text =~ /^does.+\?$/ || text =~ /^did.+\?$/
    end

    def is_characteristic_definition?
      text =~ /\bhas\b/ || text =~ /\bhave\b/
    end

    def is_category_question?
      text =~ /^is.+\?$/ || text =~ /^was.+\?$/
    end

    def is_category_definition?
      ! is_category_question? && ! is_characteristic_definition? && ! is_characteristic_question?
    end

    def is_question?
      is_category_question? || is_characteristic_question?
    end

    def nouns
      sentence.nouns
    end

    def sentence
      @sentence ||= Grammar::SentenceParser.parse(text)
    end

    def singularized_nouns
      nouns.map(&:singularize)
    end

    def subject
      return @subject if @subject
      if this_subject = sentence.subject
        @subject = IsA::Category.find_or_create_by(name: this_subject)
      end
    end

    def set_category
      subject.is_a! category
    end

    def set_characteristic
      subject.has! characteristic
    end

  end
end
