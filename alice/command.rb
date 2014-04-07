module Alice

  class Command

    include Mongoid::Document

    field :name
    field :indicators, type: Array, default: []
    field :handler_class
    field :response_kind, default: :message

    attr_accessor :message

    def self.parse(nick, message)
      return unless command = fuzzy_find(message)
      command.klass.process(nick, message)
    end

    def self.fuzzy_find(message)
      message = message.downcase.gsub(/[^a-zA-Z0-9\/\\\s]/, '')
      indicators = Alice::Parser::NgramFactory.new(message.split.uniq.join(' ')).omnigrams.to_a.flatten.uniq
      matches = Alice::Command.in(indicators: indicators)
      return unless matches.present?
      command = matches.max{|command| (command.indicators | indicators).count }
      [indicators & command.indicators].flatten.count >= command.minimum_indicators && command || nil
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
