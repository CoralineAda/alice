module Alice

  module Util

    class Mediator

      def self.bot_name
        Alice.bot.bot.nick
      end

      def self.non_op?(channel_user)
        ! op?(channel_user)
      end

      def self.op?(nick)
        op_nicks.include?(nick.downcase)
      end

      def self.exists?(nick)
        user_nicks.any?{|n| n =~ /^#{nick}$/i}
      end

      def self.user_list
        Alice.bot.bot.user_list
      end

      def self.is_bot?(nick)
        Alice.bot.bot.nick == nick
      end

      def self.default_channel
        Alice.bot.bot.channels.first
      end

      def self.default_user
        default_channel.users.keys.last
      end

      def self.user_nicks
        user_list.map(&:nick).map(&:downcase)
      end

      def self.op_nicks
        default_channel.ops.map(&:nick).map(&:downcase)
      end

      def self.send_raw(message)
        text = Alice::Util::Sanitizer.process(message)
        text = Alice::Util::Sanitizer.initial_upcase(text)
        Alice.bot.bot.channels.first.msg(text)
      end

      def self.user_from(channel_user)
        User.from(channel_user)
      end

      def self.reply_with(channel, message)
        text = Alice::Util::Sanitizer.process(message)
        text = Alice::Util::Sanitizer.initial_upcase(text)
        Alice.bot.bot.channels.select{|c| c == channel}.first.msg(text)
      end

      def self.emote(channel, message)
        text = Alice::Util::Sanitizer.process(message)
        text = Alice::Util::Sanitizer.initial_downcase(text)
        Alice.bot.bot.channels.select{|c| c == channel}.first.action(text)
      end

    end

  end

end