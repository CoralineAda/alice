module Alice
  module Util
    class Bot
      attr_accessor :bot

      def initialize
        self.bot = ::Cinch::Bot.new do
          configure do |config|
            config.server = ENV["IRC_SERVER"]
            config.port = ENV["IRC_PORT"]
            config.channels = [ENV['PRIMARY_CHANNEL'], ENV['DEBUG_CHANNEL']]
            config.nick = ENV['IRC_NICK']
            config.user = ENV['IRC_USER']
            config.logger = Raad::Logger
            config.plugins.plugins = [
              Pipeline::Listener
            ]
            config.password = ENV['USER_PASS']
            config.messages_per_second = 1
          end
        end
      end

      def join(channel_name)
        self.bot.join(channel_name)
      end

      def leave(channel_name)
        self.bot.channels.select{|c| c.name == channel_name}.first.part
      end

      def start
        self.bot.start
        self.bot
      end

      def stop
        self.bot.stop
      end

    end

  end
end
