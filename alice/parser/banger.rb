module Alice

  module Parser

    class Banger

      attr_accessor :command_string

      include AASM

      aasm do
        state :unparsed, initial: true
        state :bang
        state :verb
        state :preposition
        state :person
        state :object

        event :bang do
          transitions :from => :unparsed, :to => :bang, :guard => :has_bang?
        end

        event :verb do
          transitions :from => :bang, :to => :verb, :guard => :known_verb?
        end

        event :person do
          transitions :from => :verb, :to => :person, :guard => :known_person?
        end

        event :object do
          transitions :from => :verb, :to => :object, :guard => :known_object?
        end

      end

      def initialize(command_string)
        self.command_string = command_string
      end

      def parse!
        bang && verb && (known_verb? || person || object) && command
      rescue
        return false
      end

      def has_bang?
        self.command_string.content[0] == "!"
      end

      def known_verb?
        command.present?
      end

      def known_person?
        User.like(command_string.predicate) || User.like(command_string.subject)
      end

      def known_object?
        Item.like(command_string.subject) ||
        Item.like(command_string.predicate) ||
        Beverage.like(command_string.subject) ||
        Beverage.like(command_string.predicate)
      end

      def command
        @command ||= Command.any_in(verbs: command_string.verb).first
      end

    end

  end

end

