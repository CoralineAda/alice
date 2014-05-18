require 'cinch'

module Alice

  class Listener

    include Cinch::Plugin

    match /(.+)/, method: :parse_command, use_prefix: false

    attr_accessor :message, :match

    def parse_command(message_obj, match)
      self.message = message_obj
      self.match = match
      track && respond
    end

    def process_direct_command(channel_user, message)
      direct_command.invoke!
    end

    def process_fuzzy_command(channel_user, message)
      return unless fuzzy_command && parsed_command
      fuzzy_command.process(
        sender: channel_user.user.nick,
        command: parsed_command,
        raw_command: command_string
      )
    end

    def direct_command
      return unless match[0] == "!"
      Alice::DirectCommand.process(command_string)
    end

    def fuzzy_command
      return if match[0] == "!"
      # return unless match =~ /match/i
      Alice::FuzzyCommand.process(command_string)
    end

    def parsed_command
      @parsed_command ||= Alice::Command.parse(message)
    end

    def respond
      return unless response
      Alice::Util::Mediator.reply_to(channel_user, response.content) and return true if response.kind == :reply
      Alice::Util::Mediator.emote_to(channel_user, response.content) and return true if response.kind == :action
    end

    def command_string
      @command_string ||= Alice::CommandString.new(content: self.match)
    end

    def response
      return @response if @response.present?
      @response = direct_command && direct_command.invoke!
      @response ||= fuzzy_command && fuzzy_command.invoke!
      @response
    end

    def track
      Alice::User.track(message.user.nick)
    end

  end

end
