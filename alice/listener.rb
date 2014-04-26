require 'cinch'

module Alice

  class Listener

    include Cinch::Plugin

    match /(.+)/, method: :parse_command, use_prefix: false

    attr_accessor :message, :param

    def parse_command(message_obj, match)
      self.message = message_obj
      self.param = match
      track && respond
    end

    def process_direct_command(channel_user, message)
      return unless direct_command
      direct_command.process(command_string)
    end

    def process_fuzzy_command(channel_user, message)
      return unless fuzzy_command
      return unless parsed_command
      fuzzy_command.process(
        sender: channel_user.user.nick,
        command: parsed_command,
        raw_command: command_string
      )
    end

    def direct_command
      return unless param[0] == "!"
      Alice::DirectCommand.process(command_string)
    end

    def fuzzy_command
      return if param[0] == "!"
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
      @command_string ||= Alice::CommandString.new(content: self.param)
    end

    def response
      return @response if @response.present?
      @response = direct_command && direct_command.process
      @response ||= fuzzy_command && fuzzy_command.process
    end

    def track
      Alice::User.find_or_create(message.user.nick).touch
    end

  end

end
