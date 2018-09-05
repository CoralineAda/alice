module Parser

  class Banger

    attr_accessor :command_string

    def self.parse(command_string)
      parser = new(command_string)
      command = parser.parse!

      if command
        {
          command: command,
          topic: ""
        }
      end
    end

    def initialize(command_string)
      self.command_string = command_string
    end

    def parse!
      if (has_bang? || has_plusplus? || has_thirteen? || has_nice?) && (known_verb? || known_person? || object) && command
        Alice::Util::Logger.info "*** Command is  \"#{command.inspect}\" "
        return command
      else
        return false
      end
    end

    def has_bang?
      self.command_string.content =~ /^\!/
    end

    def has_nice?
      self.command_string.content == "nice"
    end

    # Handle points
    def has_plusplus?
      self.command_string.content =~ /\+\+/
    end

    # Handle number game
    def has_thirteen?
      self.command_string.content == "!13"
    end

    def known_verb?
      command.present?
    end

    def known_person?
      return false unless command.predicate
      User.like(command.predicate) || User.like(command.subject)
    end

    def known_object?
      Item.like(command.subject) ||
      Item.like(command.predicate) ||
      Beverage.like(command.subject) ||
      Beverage.like(command.predicate)
    end

    def command
      return @command if @command
      verb = command_string.content.gsub("!", "").split(' ').first
      verb = "++" if has_plusplus?
      verb = "13" if has_thirteen?
      verb = "nice" if has_nice?
      if @command = Message::Command.any_in(verbs: verb).first
        @command.subject = (sentence.nouns - [verb]).first
        @command.predicate = (sentence.nouns - [">"]).last
        @command.verb = sentence.verbs.first
      end
      @command
    end

    private

    def sentence
      @sentence ||= Grammar::SentenceParser.parse(command_string.content, keywords: nil)
    end

  end

end
