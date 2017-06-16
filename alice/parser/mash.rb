 module Parser

  class Mash

    attr_reader :command_string, :to_parse, :words

    def self.parse(command_string)
      if command = new(command_string).parse
        {
          command: command
        }
      end
    end

    def initialize(command_string)
      @command_string = command_string
      @to_parse = command_string.content.downcase.gsub(/[\?\,\!]+/, '')
      @words = to_parse.split(' ')
    end

    def parse
      return unless has_alice?
      if new_context_topic = subject ? subject.primary_nick : topic
        Context.from(new_context_topic).current!
      end
      command
    end

    def command
      @command = Message::Command.any_in(verbs: (verbs + [property]).compact).first
      @command ||= Message::Command.any_in(indicators: (verbs + [greeting] + [thanks] + [pronoun].compact)).first
      @command ||= Message::Command.any_in(indicators: "alpha").first if is_query?
      @command ||= Message::Command.default
      @command.subject = subject || subject_from_context
      @command.predicate = object || topic
      @command
    end

    def sentence
      @sentence ||= Grammar::SentenceParser.parse(to_parse)
    end

    def has_alice?
      command_string.content =~ /\b#{ENV['BOT_NAME']}\,/i
    end

    def is_query?
      command_string.content.last == "?"
    end

    def greeting
      (Grammar::LanguageHelper::GREETINGS & words).any? && "hi"
    end

    def thanks
      (sentence.nouns.include?("thanks") || sentence.verbs.include?("thank")) && "thanks"
    end

    def verbs
      verbs = (Grammar::LanguageHelper::VERBS & sentence.verbs)
      verbs = ["is"] if sentence.interrogatives.any? || sentence.contains_possessive
      verbs
    end

    def pronoun
      sentence.pronouns.first
    end

    def subject
      @subject ||= sentence.nouns.map{ |noun| ::User.from(noun) }.compact.last
      @subject ||= ::User.from(subject_from_context)
    end

    def subject_from_context
      return unless context = Context.current
      @subject_from_context ||= sentence.nominative_pronouns.any? ? Context.current.topic : nil
    end

    def object
      @object ||= sentence.nouns.map do |noun|
        ::Item.from(noun) || ::Beverage.from(noun) || ::Wand.from(noun)
      end.compact.last
    end

    def topic
      if preposition = sentence.prepositions.last
        words[(words.index(preposition)+1)..-1].join(' ')
      else
        sentence.nouns.last
      end
    end

    def property
      return @property if @property
      return unless thing = subject || object
      properties = thing.class::PROPERTIES.inject({}) do |hash, property|
        hash[property.to_s] = property.to_s.split("_").reject{ |value| value == "can" }.map{|w| w.gsub("?","")}
        hash
      end
      matches = (properties.values.flatten & words)
      matching_property = properties.find{|k,v| (v & matches).any? }
      matching_property && matching_property.first.to_sym
    end

  end

end
