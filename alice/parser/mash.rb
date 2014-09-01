module Alice

  module Parser

    class Mash

      attr_accessor :command_string
      attr_accessor :this_object

      include AASM

      aasm do
        state :unparsed, initial: true
        state :alice
        state :verb
        state :transfer_verb
        state :item
        state :noun
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
          transitions from: [:info_verb, :subject, :obect, :noun], to: :preposition, guard: :has_preposition?
        end

        event :object do
          transitions from: [:transfer_verb, :info_verb, :preposition], to: :object, guard: :has_object?
        end

        event :subject do
          transitions from: [:transfer_verb, :object], to: :subject, guard: :has_subject?
        end

      end

      def initialize(command_string)
        self.command_string = command_string
      end

      def parse_transfer
        alice &&
        transfer_verb &&
        (subject || preposition || object) ||
        (object  || preposition || object) ||
        (subject || preposition || object)
      rescue AASM::InvalidTransition
        false
      end

      def parse!
        parse_transfer
      # rescue
      #   p "Mash was unable to parse #{command_string.content}"
      #   return false
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
        User.like(command_string.predicate) || User.like(command_string.subject)
      end

      def has_object?
        self.this_object = potential_nouns.map do |word|
          Item.like(word) || Beverage.like(word)
        end.compact.first
      end

      def has_noun?
        known_object? || known_person?
      end

      def has_subject?
        has_person?
      end

      def transfer_verb?
        any_content_in?(Alice::Parser::LanguageHelper::TRANSFER_VERBS)
      end

      # Parts of speech
      # ========================================================================

      def this_object

      end

      # Util
      # ========================================================================

      def potential_nouns
        command_string.components -
        Alice::Parser::LanguageHelper::PREPOSITIONS -
        Alice::Parser::LanguageHelper::ARTICLES
      end

      def command
        @command ||= Command.any_in(verbs: command_string.verb).first
      end

      def any_content_in?(array)
        (array & split_content).count > 0
      end

      def position_of(word)
        split_content.find_index(word)
      end

      def split_content
        @split_content ||= command_string.content.split
      end

    end

  end

end

