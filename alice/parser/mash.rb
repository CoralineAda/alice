module Parser

  class Mash

    attr_accessor :command_string
    attr_accessor :sentence
    attr_accessor :this_object, :this_subject, :this_info_verb
    attr_accessor :this_transfer_verb, :this_action_verb, :this_preposition
    attr_accessor :this_relation_verb, :this_topic, :this_noun, :this_adverb
    attr_accessor :relation_verb
    attr_accessor :this_property, :this_greeting, :this_pronoun, :this_interrogative

    STRUCTURES = [
      [:to_greeting, [:to_subject]],
      [:to_object,        [:to_info_verb, [:to_object]],
                          [:to_info_verb, [:to_topic]],
                          [:to_info_verb, [:to_subject]]
      ],
      [:to_interrogative, [:to_info_verb,
                            [:to_subject, [:to_property]],
                            [:to_object, [:to_property]],
                            [:to_topic]
                          ]
      ],
      [:to_info_verb,
                          [:to_pronoun],
                          [:to_adverb],
                          [:to_subject, [:to_property]],
                          [:to_object, [:to_property]],
                          [:to_topic],
                          [:to_object, [:to_subject]]
      ],
      [:to_action_verb,   [],
                          [:to_subject, [:to_object]],
                          [:to_object, [:to_subject]]],
      [:to_transfer_verb, [:to_subject, [:to_object]],
                          [:to_object, [:to_subject]]],
    ]

  include AASM

    aasm do
      state :unparsed, initial: true
      state :alice
      state :greeting
      state :adverb
      state :verb
      state :transfer_verb
      state :info_verb
      state :relation_verb
      state :action_verb
      state :item
      state :interrogative
      state :noun
      state :object
      state :preposition
      state :person
      state :pronoun
      state :subject
      state :item
      state :topic
      state :property

      event :alice do
        transitions from: :unparsed, to: :alice, guard: :has_alice?
      end

      event :adverb do
        transitions from: [:info_verb], to: :adverb, guard: :adverb?
      end

      event :transfer_verb do
        transitions from: [:alice], to: :transfer_verb, guard: :transfer_verb?
      end

      event :greeting do
        transitions from: [:alice], to: :greeting, guard: :greeting?
      end

      event :info_verb do
        transitions from: [:alice, :interrogative], to: :info_verb, guard: :info_verb?
      end

      event :action_verb do
        transitions from: [:alice], to: :action_verb, guard: :action_verb?
      end

      event :interrogative do
        transitions from: [:alice], to: :interrogative, guard: :has_interrogative?
      end

      event :relation_verb do
        transitions from: [:alice], to: :relation_verb, guard: :relation_verb?
      end

      event :noun do
        transitions from: [:transfer_verb, :info_verb], to: :noun, guard: :has_noun?
      end

      event :pronoun do
        transitions from: :info_verb, to: :pronoun, guard: :has_pronoun?
      end

      event :topic do
        transitions from: [:info_verb], to: :topic, guard: :has_topic?
      end

      event :preposition do
        transitions from: [:info_verb, :subject, :object, :noun], to: :preposition, guard: :has_preposition?
      end

      event :object do
        transitions from: [:subject, :transfer_verb, :info_verb, :preposition,:relation_verb], to: :object, guard: :has_object?
      end

      event :subject do
        transitions from: [:greeting, :transfer_verb, :info_verb, :action_verb, :object], to: :subject, guard: :has_subject?
      end

      event :property do
        transitions from: [:subject, :object], to: :property, guard: :has_property?
      end

    end

    def initialize(command_string)
      self.command_string = command_string
      self.sentence = Sentence.new(command_string.content.downcase.gsub(/[\?\,\!]+/, '').split(' '))
    end

    def parse_transfer(structures=STRUCTURES)
      structures.map do |structure|
        head, tail = structure.first, structure[1..-1]
        if can_transition_to?(head)
          Alice::Util::Logger.info "*** Mash state is  \"#{head}\" "
          self.public_send(head)
          sentence.remove(self.public_send(head.to_s.gsub(/to_/, 'this_')))
          return unless tail.present?
          parse_transfer(tail)
        end
      end
    end

    def can_transition_to?(event)
      aasm.may_fire_event?(event.to_s.gsub(/^to_/, '').to_sym)
    end

    def to_info_verb
      info_verb
    end

    def to_action_verb
      action_verb
    end

    def to_greeting
      greeting
    end

    def to_adverb
      adverb
    end

    def to_interrogative
      interrogative
    end

    def to_pronoun
      pronoun
    end

    def to_transfer_verb
      transfer_verb
    end

    def to_object_or_subject
      to_object || to_subject
    end

    def to_object_and_subject
      to_object && to_subject
    end

    def to_object
      object
    end

    def to_subject
      subject
    end

    def to_topic
      topic
    end

    def to_property
      property
    end

    def parse!
      alice
      parse_transfer
      command
    rescue AASM::InvalidTransition => e
      Alice::Util::Logger.info "*** Mash can't set state: \"#{e}\" "
    ensure
      Alice::Util::Logger.info "*** Final mash state is  \"#{aasm.current_state}\" "
      Alice::Util::Logger.info "*** Command state is  \"#{command && command.name}\" "
      return command
    end

    def state
      aasm.current_state
    end

    # Guards
    # ========================================================================

    def has_alice?
      command_string.content =~ /\balice/i
      sentence.remove("Alice")
    end

    def has_preposition?
      self.this_preposition = any_content_in?(Grammar::LanguageHelper::PREPOSITIONS)
    end

    def has_pronoun?
      if self.this_pronoun = any_content_in?(Grammar::LanguageHelper::PRONOUNS)
        self.this_info_verb = "converse"
      end
    end

    def info_verb?
      self.this_info_verb = any_content_in?(Grammar::LanguageHelper::INFO_VERBS)
      self.this_info_verb ||= "is" if any_content_in?(Grammar::LanguageHelper::INTERROGATIVES)
      self.this_info_verb ||= "is" if sentence.contains_possessive
      self.this_info_verb
    end

    def has_interrogative?
      self.this_pronoun = "who" if any_content_in?(["who"]) && info_verb?
      self.this_pronoun
    end

    def adverb?
      self.this_adverb = any_content_in?(Grammar::LanguageHelper::ADVERBS)
    end

    def relation_verb?
      self.this_relation_verb = any_content_in?(Grammar::LanguageHelper::RELATION_VERBS)
    end

    def transfer_verb?
      self.this_transfer_verb = any_content_in?(Grammar::LanguageHelper::TRANSFER_VERBS)
    end

    def greeting?
      self.this_greeting = "hi" if any_content_in?(Grammar::LanguageHelper::GREETINGS)
    end

    def action_verb?
      self.this_action_verb = any_content_in?(Grammar::LanguageHelper::ACTION_VERBS)
    end

    def verb
     self.this_relation_verb || self.this_transfer_verb || self.this_info_verb || self.this_action_verb
    end

    def has_person?
      (command_string.predicate.present? && ::User.like(command_string.predicate)) ||
      (command_string.subject.present? && ::User.like(command_string.subject)) ||
      ::User.from(command_string.subject) || ::User.from(command_string.predicate)
    end

    def has_object?
      self.this_object = Item.from(potential_nouns.join(' ')) ||
                         Beverage.from(potential_nouns.join(' ')) ||
                         Wand.from(potential_nouns.join(' '))
    end

    def has_noun?
      self.this_noun = has_object? || has_person?
    end

    def has_subject?
      self.this_subject ||= has_person?
    end

    def has_topic?
      if this_object
        if match = Context.from(command_string.subject, this_object)
          self.this_topic = match
          self.this_info_verb = "converse"
          Alice::Util::Logger.info "*** Topic is \"#{match.topic}\" "
        end
      elsif match = Context.from(command_string.subject)
        self.this_topic = match
        self.this_info_verb = "converse"
        Alice::Util::Logger.info "*** Topic is \"#{match.topic}\" "
      elsif match = Context.from(command_string.predicate)
        self.this_topic = match
        self.this_info_verb = "converse"
        Alice::Util::Logger.info "*** Topic is \"#{match.topic}\" "
      elsif match = Context.current
        self.this_topic = match
        self.this_info_verb = "converse"
        Alice::Util::Logger.info "*** Topic is \"#{match.topic}\" "
      end
    end

    def has_property?
      thing = self.this_subject || self.this_object
      map = thing.class::PROPERTIES.inject({}) do |hash, property|
        hash[property] = property.to_s.split("_").reject{|value| value == "can"}.map{|w| w.gsub("?","")}
        hash
      end
      candidate = (map.values.flatten & sentence).first
      match = map.select{|k,v| v.include?(candidate) }.first
      self.this_property = match && match[0]
    end

    # Util
    # ========================================================================

    def potential_nouns
      command_string.probable_nouns
    end

    def command
      return if state == :unparsed
      @command ||= Message::Command.any_in(verbs: verb.to_s).first
      @command ||= Message::Command.any_in(verbs: this_property).first
      @command ||= Message::Command.any_in(indicators: verb).first
      @command ||= Message::Command.any_in(indicators: this_greeting).first
      @command ||= Message::Command.any_in(indicators: this_pronoun).first
      @command ||= Message::Command.any_in(indicators: "alpha").first
    end

    def any_method_like?(array)
      array.select { |n| sentence.map { |m| Regexp.new(m, 'i').match(n) }.any? }
    end

    def method_from(name)
      name.gsub(" ", "_")
    end

    def properties(klass)
      method_names = klass::PROPERTIES.map{ |method| method.to_s.gsub(/_/, ' ') }
      method_names.select{ |n| sentence.map{ |m| Regexp.new(m, 'i').match(n) }.any? }
    end

    def any_content_in?(array)
      common = (array & sentence)
      common.count > 0 && common.first
    end

    def position_of(word)
      split_content.find_index(word)
    end

    def split_content
      @split_content ||= begin
        bits = command_string.content.split.map(&:downcase)
        pieces = bits.map{|word| Lingua.stemmer(word.downcase)}
        (bits + pieces).uniq
      end
    end

    class Sentence < Array
      def contains_possessive
        self.select{|word| word =~ /\'s/}.any?
      end
      def remove(what)
        return self if what.nil?
        regexp = Regexp.new(what.to_s + "(?:'s)?", 'i')
        result = self.reject!{|e| regexp.match(e) }
        result
      end
    end

  end

end
