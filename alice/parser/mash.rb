module Parser

  class Mash

    attr_accessor :command_string
    attr_accessor :sentence, :unparsed_sentence
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

    def self.parse(command_string)
      if command = new(command_string).parse
        {
          command: command
        }
      end
    end

    def initialize(command_string)
      self.command_string = command_string
      to_parse = command_string.content.downcase.gsub(/[\?\,\!]+/, '')
      self.unparsed_sentence = to_parse.split(' ')
      self.sentence = Grammar::SentenceParser.parse(to_parse)
    end

    def parse
      alice
      binding.pry
      parse_transfer
      command
    rescue AASM::InvalidTransition => e
      Alice::Util::Logger.info "*** Mash can't set state: \"#{e}\" "
    ensure
      Alice::Util::Logger.info "*** Final mash state is  \"#{aasm.current_state}\" "
      Alice::Util::Logger.info "*** Command state is  \"#{command && command.name}\" "
      command
    end

    def state
      aasm.current_state
    end

    def parse_transfer(structures=STRUCTURES)
      structures.map do |structure|
        head, tail = structure.first, structure[1..-1]
        if can_transition_to?(head)
          Alice::Util::Logger.info "*** Mash state is  \"#{head}\" "
          sentence.remove(self.public_send(head.to_s.gsub(/to_/, 'this_')))# unless head == :info_verb
          self.public_send(head)
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

    # Guards
    # ========================================================================

    def has_alice?
      sentence.nouns.join(' ') =~ /\balice/i && sentence.remove("alice")
    end

    def has_preposition?
      self.this_preposition = sentence.prepositions.first
    end

    def has_pronoun?
      if self.this_pronoun = (Grammar::LanguageHelper::INFO_VERBS & sentence.pronouns).first
        self.this_info_verb = "converse"
      end
    end

    def info_verb?
      self.this_info_verb = (Grammar::LanguageHelper::INFO_VERBS & sentence.verbs).first
      self.this_info_verb ||= "is" if sentence.interrogatives.any?
      self.this_info_verb ||= "is" if sentence.contains_possessive
      self.this_info_verb
    end

    def has_interrogative?
      self.this_pronoun = "who" if sentence.pronouns.include?("who")
    end

    def adverb?
      self.this_adverb = (Grammar::LanguageHelper::ADVERBS & sentence.adverbs).first
    end

    def relation_verb?
      self.this_relation_verb = (Grammar::LanguageHelper::RELATION_VERBS & sentence.verbs).first
    end

    def transfer_verb?
      self.this_transfer_verb = (Grammar::LanguageHelper::TRANSFER_VERBS & sentence.verbs).first
    end

    def greeting?
      self.this_greeting = "hi" if (Grammar::LanguageHelper::GREETINGS & unparsed_sentence).first
    end

    def action_verb?
      self.this_action_verb = (Grammar::LanguageHelper::ACTION_VERBS & sentence.verbs).first
    end

    def verb
     self.this_relation_verb || self.this_transfer_verb || self.this_info_verb || self.this_action_verb
    end

    def has_person?
      sentence.nouns.map{ |noun| ::User.from(noun) }.compact.first
    end

    def has_object?
      joined_nouns = sentence.nouns.join(' ')
      self.this_object = Item.from(joined_nouns) || Beverage.from(joined_nouns) || Wand.from(joined_nouns)
    end

    def has_noun?
      self.this_noun = sentence.nouns.first
    end

    def has_subject?
      self.this_subject ||= has_person?
    end

    def has_topic?
      if this_object
        if match = Context.from(sentence.nouns.first, sentence.nouns.last)
          self.this_topic = match
          self.this_info_verb = "converse"
          Alice::Util::Logger.info "*** Topic is \"#{match.topic}\" "
        end
      elsif match = Context.from(sentence.nouns.first)
        self.this_topic = match
        self.this_info_verb = "converse"
        Alice::Util::Logger.info "*** Topic is \"#{match.topic}\" "
      elsif match = Context.from(sentence.nouns.last)
        self.this_topic = match
        self.this_info_verb = "converse"
        Alice::Util::Logger.info "*** Topic is \"#{match.topic}\" "
      elsif match = Context.current
        self.this_topic = match
        self.this_info_verb = "converse"
        Alice::Util::Logger.info "*** Topic is \"#{match.topic}\" "
      end
      match
    end

    def has_property?
      thing = self.this_subject || self.this_object
      map = thing.class::PROPERTIES.inject({}) do |hash, property|
        hash[property] = property.to_s.split("_").reject{ |value| value == "can" }.map{|w| w.gsub("?","")}
        hash
      end
      candidate = (map.values.flatten & unparsed_sentence).first
      match = map.select{|k,v| v.include?(candidate) }.first
      self.this_property = match && match[0]
    end

    # Util
    # ========================================================================

    def potential_nouns
      sentence.nouns
    end

    def command
      return if state == :unparsed
      @command ||= Message::Command.any_in(verbs: verb.to_s).first
      @command ||= Message::Command.any_in(verbs: this_property).first
      @command ||= Message::Command.any_in(indicators: verb).first
      @command ||= Message::Command.any_in(indicators: this_greeting).first
      @command ||= Message::Command.any_in(indicators: "alpha").first
      # @command ||= Message::Command.any_in(indicators: this_pronoun).first
      @command.subject = this_subject
      @command.predicate = this_object
      @command
    end

    def any_method_like?(array)
      array.select { |n| unparsed_sentence.map { |m| Regexp.new(m, 'i').match(n) }.any? }
    end

    def method_from(name)
      name.gsub(" ", "_")
    end

    def properties(klass)
      method_names = klass::PROPERTIES.map{ |method| method.to_s.gsub(/_/, ' ') }
      method_names.select{ |n| unparsed_sentence.map{ |m| Regexp.new(m, 'i').match(n) }.any? }
    end

  end

end
