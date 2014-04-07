module Alice

  class Command

    include Mongoid::Document

    field :name
    field :indicators, type: Array, default: []
    field :handler_class
    field :response_kind, default: :message

    attr_accessor :message

    def self.parse(message)
      return unless command = fuzzy_find(message)
      eval(command.handler_class).process('bob', message)
    end

    def self.fuzzy_find(message)
      message = message.gsub(/[^a-zA-Z0-9\/\\\s]/, '')
      message = message.downcase
      indicators = Alice::Parser::NgramFactory.new(message.split.uniq.join(' ')).omnigrams.to_a.flatten.uniq
      matches = Alice::Command.in(indicators: indicators)
      return unless matches.present?
      matches.max{|command| (command.indicators | indicators).count }
    end

    def terms=(words)
      self.indicators = [words.map(&:downcase) + words.map{|word| Lingua.stemmer(word.downcase)}].flatten.uniq
    end

  end

end
