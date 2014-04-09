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
        channel_user.channel.ops.map(&:nick).include?(channel_user.user.nick)
      end

      def self.exists?(nick)
        Alice.bot.user_list.find(nick)
      end

      def self.user_list
        Alice.bot.bot.user_list
      end

      def self.is_bot?(nick)
        Alice.bot.bot.nick == nick
      end

      def self.reply_to(channel_user, message)
        channel_user.reply(Alice::Util::Sanitizer.process(message).capitalize)
      end

      def self.emote_to(channel_user, message)
        channel_user.action_reply(Alice::Util::Sanitizer.process(message).capitalize)
      end

    end

  end

end