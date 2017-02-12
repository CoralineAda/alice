module Message
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

    store_in collection: 'commands'

    attr_accessor :message, :terms, :subject, :predicate, :verb

    def self.default
      Command.where(handler_class: "Handlers::Unknown").first || Command.new(handler_class: 'Handlers::Unknown')
    end

    def self.words_from(message)
      Grammar::NgramFactory.filtered_grams_from(message)
    end

    def self.verb_from(trigger)
      Alice::Logger.info("*** trigger = #{trigger}")
      if verb = trigger.split(' ').select{|w| w[0] == "!"}.first
        verb[1..-1]
      elsif trigger =~ /^.+\+\+/
        "+"
      elsif trigger =~ /nice|good|kind|sweet|cool|great/i
        "nice"
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
      trigger = message.trigger.downcase
      command_string = ::Message::CommandString.new(trigger)
      if match = Parser::Banger.parse(command_string)
        match[:command].message = message
      elsif match = Parser::Mash.parse(command_string)
        match[:command].message = message
#        find_or_create_context(match[:topic]) if match[:topic]
      else
        command = find_verb(trigger) if (trigger.include?("++") || trigger.downcase.include?(ENV['BOT_SHORT_NAME'].downcase))
        command.message = message if command
        match = { command: command || default }
      end
      Alice::Util::Logger.info "*** Executing #{match[:command].name} with \"#{trigger}\" with context #{Context.current && Context.current.topic || "none"} ***"
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

    def self.find_or_create_context(topic)
      context = Context.from(topic) || Context.create(topic: topic)
      context.current!
      context
    end

    def self.process(message)
      command = from(message)[:command]
      message.response_type = command.response_kind
      command.invoke!
      [command, message]
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
      Util::Randomizer.one_chance_in(self.one_in_x_odds)
    end

    def invoke!
      return unless self.handler_class
      return unless meets_odds?
      if needs_cooldown?
        self.message.response = ""
        return self.message
      end
      self.update_attribute(:last_said_at, Time.now)
      eval(self.handler_class).process(self.message, self, self.handler_method)
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
end
