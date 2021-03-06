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
      @to_parse = command_string.content.downcase
      @words = to_parse.gsub(/[\?\!]*/, '').split(' ')
      if subject
        context = Context.find_or_create(subject.primary_nick, @words.join(" "))
        context.current!
      end
    end

    def parse
      return unless has_alice?
      return if self.words.find{|word| word =~ /^\!/}
      command
    end

    def adjectives
      sentence.adjectives
    end

    def command
      return @command if @command
      @command = Message::Command.any_in(indicators: "alpha").first if is_query?
      @command ||= Message::Command.any_in(verbs: (verbs + [property])).not.in(stop_words: self.words).first
      @command ||= Message::Command.any_in(indicators: (verbs + adjectives + [property] + [greeting] + [thanks] + [pronoun].compact)).not.in(stop_words: self.words).first
      if @command && @command.subject.nil?
        @command.subject = subject || subject_from_context
        @command.predicate = object || topic
      end
      @command
    end

    def greeting
      omnigrams = Grammar::NgramFactory.new(words.join(' ')).omnigrams
      omnigrams.each do |omnigram|
        return "hi" if (Grammar::LanguageHelper::GREETINGS & [omnigram.join("+")]).any?
      end
      return false
    end

    def has_alice?
      return true if command_string.content =~ /\b#{ENV['BOT_NAME']}\b/i
      return true if command_string.content =~ /#{::User.bot.slack_id}/i
      false
    end

    def is_query?
      command_string.content.last == "?"
    end

    def object
      @object ||= sentence.nouns.select do |noun|
        ::Item.from(noun) || ::Beverage.from(noun) || ::Wand.from(noun)
      end.compact.last
    end

    def pronoun
      sentence.pronouns.first
    end

    def property
      return @property if @property
      return unless thing = subject || object
      return unless defined? thing.class::PROPERTIES
      properties = thing.class::PROPERTIES.inject({}) do |hash, property|
        hash[property.to_s] = property.to_s.split("_").reject{ |value| value == "can" }.map{|w| w.gsub("?","")}
        hash
      end
      matches = (properties.values.flatten & words)
      matching_property = properties.find{|k,v| (v & matches).any? }
      matching_property && matching_property.first.to_sym
    end

    def sentence
      @sentence ||= Grammar::SentenceParser.parse(to_parse)
    end

    def subject
      @subject ||= sentence
        .nouns
        .reject{ |noun| noun.downcase == ENV['BOT_NAME'].downcase }
        .reject{ |noun| noun =~ /#{::User.bot.slack_id}/i }
        .map{ |noun| ::User.from(noun) }
        .compact
        .last
    end

    def subject_from_context
      return unless sentence.nominative_pronouns.any?
      context = Context.with_pronouns_matching(sentence.nominative_pronouns)
      @subject_from_context ||= context ? context.context_user : nil
    end

    def thanks
      (sentence.nouns.include?("thanks") || sentence.verbs.include?("thank")) && "thanks"
    end

    def topic
      if preposition = sentence.prepositions.last
        return if preposition == "@"
        words[(words.index(preposition)+1)..-1].join(' ')
      else
        sentence.nouns.last
      end
    end

    def verbs
      sentence.verbs
    end

  end

end
