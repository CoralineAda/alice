module Alice

  module Util

    class Mediator

      def self.bot_name
        Alice.bot.bot.nick
      end

      def self.non_op?(channel_user)
        ! op?(channel_user)
      end

      def self.op?(channel_user)
        nick = channel_user.respond_to?(:user) ? channel_user.user.nick : channel_user
        op_nicks.include?(nick)
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
        Alice.bot.bot.channels.last
      end

      def self.default_user
        default_channel.users.keys.last
      end

      def self.user_nicks
        channel.user_list.map(&:nick).map(&:downcase)
      end

      def self.op_nicks
        channel.ops.map(&:nick).map(&:downcase)
      end

      def self.send_raw(message)
        text = Alice::Util::Sanitizer.process(message)
        text = Alice::Util::Sanitizer.initial_upcase(text)
        Alice.bot.bot.channels.first.msg(text)
      end

      def self.user_from(channel_user)
        User.with_nick_like(channel_user.user.nick)
      end

      def self.reply_to(channel_user, message)
        text = Alice::Util::Sanitizer.process(message)
        text = Alice::Util::Sanitizer.initial_upcase(text)
        text = user_from(channel_user).apply_filters(text)
        channel_user.reply(text)
      end

      def self.emote_to(channel_user, message)
        text = Alice::Util::Sanitizer.process(message)
        text = Alice::Util::Sanitizer.initial_downcase(text)
        channel_user.action_reply(text)
      end

    end

  end

end