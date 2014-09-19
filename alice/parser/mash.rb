module Alice

  module Parser

    class Mash

      attr_accessor :command_string
      attr_accessor :sentence
      attr_accessor :this_object, :this_subject, :this_verb

      include AASM

      aasm do
        state :unparsed, initial: true
        state :alice
        state :verb
        state :transfer_verb
        state :info_verb
        state :item
        state :noun
        state :object
        state :preposition
        state :person
        state :subject
        state :item

        event :alice do
          transitions from: :unparsed, to: :alice, guard: :has_alice?
        end

        event :interrogative_pronoun do
          transitions from: :alice, to: :interrogative_pronoun, guard: :transfer_verb?
        end

        event :transfer_verb do
          transitions from: [:alice, :interrogative_pronoun], to: :transfer_verb, guard: :transfer_verb?
        end

        event :info_verb do
          transitions from: [:alice, :interrogative_pronoun], to: :info_verb, guard: :info_verb?
        end

        event :noun do
          transitions from: [:transfer_verb, :info_verb, :interrogative_pronoun], to: :noun, guard: :has_noun?
        end

        event :preposition do
          transitions from: [:info_verb, :subject, :object, :noun], to: :preposition, guard: :has_preposition?
        end

        event :object do
          transitions from: [:subject, :transfer_verb, :info_verb, :preposition], to: :object, guard: :has_object?
        end

        event :subject do
          transitions from: [:transfer_verb, :info_verb, :object], to: :subject, guard: :has_subject?
        end

      end

      def initialize(command_string)
        self.command_string = command_string
        self.sentence = Sentence.new(command_string.content.split(' '))
      end

      def parse_transfer
        alice &&
        (to_transfer_verb && (from_subject_to_object || object_to_subject)) ||
        (from_info_verb_to_object)
      end

      def to_info_verb
        info_verb
      rescue AASM::InvalidTransition
        false
      end

      def to_transfer_verb
        transfer_verb
      rescue AASM::InvalidTransition
        false
      end

      def from_info_verb_to_object
        info_verb && (to_object || to_subject)
      rescue AASM::InvalidTransition
        false
      end

      def to_object
        object
      rescue AASM::InvalidTransition
        false
      end

      def to_subject
        subject
      rescue AASM::InvalidTransition
        false
      end

      def from_subject_to_object
        subject && (may_preposition? && preposition && object) || object
      rescue AASM::InvalidTransition
        false
      end

      def object_to_subject
        object && (may_preposition? && preposition && subject) || subject
      rescue AASM::InvalidTransition
        false
      end

      def parse!
        parse_transfer
      # rescue
      #   p "Mash was unable to parse #{command_string.content}"
      #   return false
      end

      def state
        aasm.current_state
      end

      # Guards
      # ========================================================================

      def has_alice?
        command_string.content =~ /\balice/i
      end

      def has_preposition?
        any_content_in?(Alice::Parser::LanguageHelper::PREPOSITIONS)
      end

      def info_verb?
        any_content_in?(Alice::Parser::LanguageHelper::INFO_VERBS)
      end

      def known_verb?
        command.present?
      end

      def has_person?
        (command_string.predicate && User.like(command_string.predicate)) ||
        (command_string.subject && User.like(command_string.subject)) ||
        User.from(command_string.subject)
      end

      def has_object?
        self.this_object = Item.from(potential_nouns.join(' ')) || Beverage.from(potential_nouns.join(' '))
      end

      def has_noun?
        known_object? || known_person?
      end

      def has_subject?
        self.this_subject ||= has_person?
      end

      def transfer_verb?
        self.this_verb = any_content_in?(Alice::Parser::LanguageHelper::TRANSFER_VERBS)
        self.sentence.remove(this_verb)
      rescue AASM::InvalidTransition
        false
      end

      # Parts of speech
      # ========================================================================

      # Util
      # ========================================================================

      def potential_nouns
        command_string.components - ["Alice"] - Alice::Parser::LanguageHelper::PREPOSITIONS - Alice::Parser::LanguageHelper::ARTICLES
      end

      def command
        @command ||= Command.any_in(verbs: command_string.verb).first
      end

      def any_content_in?(array)
        common = (array & split_content)
        common.count > 0 && common.first
      end

      def position_of(word)
        split_content.find_index(word)
      end

      def split_content
        @split_content ||= command_string.content.split
      end

      class Sentence < Array
        def remove(what)
          self.reject!{|e| e == what}
        end
      end

    end

  end

end

