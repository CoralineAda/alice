require 'pry'

class Command

  include Mongoid::Document

  field :name
  field :verbs, type: Array, default: []
  field :stop_words, type: Array, default: []
  field :indicators, type: Array, default: []
  field :handler_class
  field :handler_method
  field :response_kind, default: :message
  field :canned_response
  field :cooldown_minutes, type: Integer, default: 0
  field :one_in_x_odds, type: Integer, default: 1
  field :last_said_at, type: DateTime

  index({ verbs:      1 }, { unique: true })
  index({ indicators: 1 }, { unique: true })
  index({ stop_words: 1 }, { unique: true })

  validates_uniqueness_of :name
  validates_presence_of :name, :handler_class

  attr_accessor :message, :terms

  def self.default
    Command.where(handler_class: "Handlers::Unknown").first || Command.new(handler_class: 'Handlers::Unknown')
  end

  def self.words_from(message)
    Alice::Parser::NgramFactory.filtered_grams_from(message)
  end

  def self.verb_from(trigger)
    if verb = trigger.split(' ').select{|w| w[0] == "!"}.first
      verb[1..-1]
    elsif trigger =~ /^.+\+\+/
      "+"
    elsif trigger == "13"
      "13"
    end
  end

  def self.best_verb_match(matches, verbs=[])
    matches.sort do |a,b|
      (a.verbs & verbs).count <=> (b.verbs & verbs).count
    end.last
  end

  def self.best_indicator_match(matches, indicators=[])
    matches.sort do |a,b|
      (a.indicators.to_a & indicators).count <=> (b.indicators.to_a & indicators).count
    end.last
  end

  def self.from(message)
    trigger = message.trigger
    command_string = CommandString.new(trigger)
    match = Alice::Parser::Banger.new(command_string).parse!
    match ||= Alice::Parser::Mash.new(command_string).parse!
    if match
      match.message = message
      p "*** Executing #{match.name} with #{trigger} ***"
    else
      match = default
    end
    match
  end

  def self.find_verb(trigger)
    if verb = verb_from(trigger)
      match = any_in(verbs: verb).first
    elsif verbs = words_from(trigger).flatten.uniq
      matches = with_verbs(verbs).without_stopwords(verbs)
      match = best_verb_match(matches, verbs)
    end
  end

  def self.find_indicators(trigger)
    indicator_words = words_from(trigger)
    grams = indicator_words.map{|words| words.join(' ')}
    with_indicators(grams).without_stopwords(indicator_words).last
  end

  def self.process(message)
    command = from(message)
    message.response_type = command.response_kind
    command.invoke!
  end

  def self.with_verbs(verbs)
    Command.excludes(verbs: []).in(verbs: verbs)
  end

  def self.with_indicators(indicators)
    Command.excludes(indicators: []).any_in(indicators: indicators)
  end

  def self.without_stopwords(verbs)
    Command.not_in(stop_words: verbs)
  end

  def needs_cooldown?
    return false unless self.last_said_at
    return false unless self.cooldown_minutes.to_i > 0
    Time.now < self.last_said_at + self.cooldown_minutes.minutes
  end

  def meets_odds?
    Alice::Util::Randomizer.one_chance_in(self.one_in_x_odds)
  end

  def invoke!
    return unless self.handler_class
    return unless meets_odds?
    if needs_cooldown?
      self.message.response = ""
      return self.message
    end
    self.update_attribute(:last_said_at, Time.now)
    eval(self.handler_class).process(self.message, self.handler_method)
  end

  def terms
    @terms || TermList.new(self.verbs)
  end

  def terms=(words)
    @terms = TermList.new(words)
  end

  class TermList
    attr_accessor :words
    def initialize(terms=[])
      self.words = convert(terms)
    end

    def <<(terms)
      self.words << convert(terms)
      self.words = self.words.flatten.uniq
    end

    def convert(terms)
      [
        terms.map(&:downcase),
        terms.map{|term| Lingua.stemmer(term.downcase)}
      ].flatten.uniq
    end

    def to_a
      self.words
    end

  end

end
