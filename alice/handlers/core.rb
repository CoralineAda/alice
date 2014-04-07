require 'cinch'

module Alice

  module Handlers

    class Core

      include Cinch::Plugin

      match /[hi|hello|] alicebot/i, method: :greet, use_prefix: false
      match /\!cookie (.+)/, method: :cookie, use_prefix: false
      match /\!pants/, method: :pants, use_prefix: false
      match /\!help/, method: :help, use_prefix: false

      def greet(m)
        m.action_reply "greets fellow hacker #{m.user.nick}."
      end

      def cookie(m, who)
        m.action_reply "gives #{who} a cookie."
      end

      def pants(m)
        m.action_reply "giggles."
      end

      def help(m)
        m.reply("!bio sets your bio, !fact sets a fact about yoursef.")
        m.reply("Learn more about your fellow hackers by asking who they are or for me to tell you about them.")
        m.reply("I know lots of stuff. Use !facts to prove it.")
      end

      def sender_is_self?(sender, who)
        sender.user.nick == who
      end

    end

  end

end
