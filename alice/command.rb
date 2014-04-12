module Alice

  class Command

    include Mongoid::Document

    field :name
    field :indicators, type: Array, default: []
    field :stop_words, type: Array, default: []
    field :handler_class
    field :response_kind, default: :message

    index({ indicators: 1 }, { unique: true })

    validates_uniqueness_of :name
    validates_presence_of :name, :indicators, :handler_class

    attr_accessor :message

    def self.fuzzy_find(message)
      message = message.downcase.gsub(/[^a-zA-Z0-9\/\\\s]/, ' ')
      indicators = Alice::Parser::NgramFactory.omnigrams_from(message)
      matches = Alice::Command.in(indicators: indicators)
      commands = matches.select{|m| m.has_minimum_indicators?(indicators) && m.has_no_stop_words?(indicators)}
      command = commands.sort{|a,b| (a.indicators & indicators).count <=> (b.indicators & indicators).count}.last
      command || nil
    end

    def self.parse(nick, message)
      return unless command = fuzzy_find(message)
      command.klass.process(nick, message)
    end

    def has_minimum_indicators?(found_indicators)
      [found_indicators & self.indicators].flatten.count >= minimum_indicators
    end

    def has_no_stop_words?(found_indicators)
      [found_indicators & self.stop_words].flatten.count == 0
    end

    def klass
      eval(self.handler_class)
    end

    def minimum_indicators
      klass.respond_to?(:minimum_indicators) && klass.minimum_indicators || 1
    end

    def terms=(words)
      self.indicators = [words.map(&:downcase) + words.map{|word| Lingua.stemmer(word.downcase)}].flatten.uniq
    end

  end

end
