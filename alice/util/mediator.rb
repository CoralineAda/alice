module Alice

  module Util

    class Mediator

      def self.op?(channel_user)
        channel_user.channel.ops.map(&:nick).include?(channel_user.user.nick)
      end

      def self.exists?(nick)
        Alice::Bot.bot.user_list.find(nick)
      end

      def self.is_bot?(nick)
        Alice.bot.bot.nick == nick
      end

      def self.reply_to(channel_user)
      end

      def self.emote_to(channel_user)
      end

    end

  end

end