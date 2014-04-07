module Alice

  class Command

    include Mongoid::Document

    field :name
    field :indicators, type: Array, default: []
    field :stop_words, type: Array, default: []
    field :handler_class
    field :response_kind, default: :message

    attr_accessor :message

    def self.parse(nick, message)
      return unless command = fuzzy_find(message)
      command.klass.process(nick, message)
    end

    def self.fuzzy_find(message)
      message = message.downcase.gsub(/[^a-zA-Z0-9\/\\\s]/, ' ')
      indicators = Alice::Parser::NgramFactory.omnigrams_from(message)
      matches = Alice::Command.in(indicators: indicators)
      command = matches.max{|command| (command.indicators | indicators).count }
      command.has_minimum_indicators?(indicators) && command.has_no_stop_words? && command || nil
    end

    def klass
      eval(self.handler_class)
    end

    def has_minimum_indicators?(found_indicators)
      [found_indicators & self.indicators].flatten.count >= minimum_indicators
    end

    def has_no_stop_words?(found_indicators)
      [found_indicators & self.stop_words].flatten.count == 0
    end

    def minimum_indicators
      klass.respond_to?(:minimum_indicators) && klass.minimum_indicators || 1
    end

    def terms=(words)
      self.indicators = [words.map(&:downcase) + words.map{|word| Lingua.stemmer(word.downcase)}].flatten.uniq
    end

  end

end
