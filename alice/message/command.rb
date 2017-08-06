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

    attr_accessor :message, :subject, :predicate, :verb

    def self.default
      Command.where(handler_class: "Handlers::Unknown").first || Command.new(handler_class: 'Handlers::Unknown')
    end

    def self.process(message)
      trigger = message.trigger.downcase
      command_string = ::Message::CommandString.new(trigger)
      if match = Parser::Banger.parse(command_string)
        match[:command].message = message
      elsif match = Parser::Mash.parse(command_string)
        match[:command].message = message
      else
        match = { command: default }
      end
      command = match[:command]
      Alice::Util::Logger.info "*** Executing #{command.name} with \"#{trigger}\" with context #{Context.current && Context.current.topic || "none"} ***"
      message.response_type = command.response_kind
      command.invoke!
      [command, message]
    end

    def invoke!
      return unless self.handler_class
      return unless meets_odds?
      if needs_cooldown?
        self.message.response = Util::Randomizer.too_soon
        return self.message
      end
      self.update_attribute(:last_said_at, Time.now)
      eval(self.handler_class).process(self.message, self, self.handler_method)
    end

    def meets_odds?
      Util::Randomizer.one_chance_in(self.one_in_x_odds)
    end

    def needs_cooldown?
      return false unless self.last_said_at
      return false unless self.cooldown_minutes.to_i > 0
      Time.now < self.last_said_at + self.cooldown_minutes.minutes
    end

  end
end
