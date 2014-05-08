require 'cinch'

module Alice

  module Listeners

    class Nlp

      include Alice::Behavior::TracksActivity
      include Cinch::Plugin

      match /(.+)/, method: :parse_command, use_prefix: false

      attr_accessor :message, :match

      def parse_command(message_obj, params)
        message, match = message_obj, params
      end

      private

      def process_direct_command(channel_user, message)
        response = direct_command && direct_command.process(command_string)
      end

      def process_fuzzy_command(channel_user, message)
        command.klass.process(sender: channel_user.user.nick, command: command, raw_command: command_string)
      end

      def respond
        response && response.kind == :reply && Alice::Util::Mediator.reply_to(channel_user, response.content)
        response && response.kind == :action && Alice::Util::Mediator.emote_to(channel_user, response.content)
      end

      def command
        @command ||= Alice::Command.parse(message)
      end

      def command_string
        @command_string ||= Alice::CommandString.new(message)
      end

      def direct_command
        return unless message[0] == "!"
        Alice::DirectCommand.process(command_string)
      end

      def response
        direct_command || command || nil
      end

    end

  end

end
