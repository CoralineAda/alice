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
      if has_bang? && (known_verb? || person || object) && command
        Alice::Util::Logger.info "*** Command is  \"#{command.inspect}\" "
        return command
      else
        return false
      end
    end

    def has_bang?
      self.command_string.content =~ /^\!/
    end

    def known_verb?
      command.present?
    end

    def known_person?
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
      if @command = Message::Command.any_in(verbs: verb).first
        @command.subject = (sentence.nouns - [verb]).first
        @command.predicate = (sentence.nouns - [">"]).last
        @command.verb = sentence.verbs.first
      end
      @command
    end

    private

    def sentence
      @sentence ||= Grammar::SentenceParser.parse(command_string.content)
    end

  end

end
