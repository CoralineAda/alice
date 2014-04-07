require 'cinch'

module Alice

  module Listeners

    class Bio

      include Cinch::Plugin

      match /^\!bio (.+)/, method: :set_bio, use_prefix: false
      match /^\!fact (.+)/, method: :set_factoid, use_prefix: false
      match /^\!twitter (.+)/, method: :set_twitter, use_prefix: false
      match /^FACT: (.+)/, method: :set_anonymous_factoid, use_prefix: false

      def set_bio(m, text)
        Alice::User.set_bio(m.user.nick, text)
        m.action_reply("nods.")
      end

      def set_factoid(m, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          Alice::User.set_factoid(m.user.nick, text)
          m.action_reply("makes a note.")
        else
          m.action_reply("calls BS on #{m.user.nick}.")
        end
      end

      def set_anonymous_factoid(m, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          Alice::Factoid.create(text)
          m.action_reply("listens carefully and nods to herself.")
        end
      end

      def set_twitter(m, handle)
        Alice::User.set_twitter(m.user.nick, handle)
        m.action_reply("considers following #{handle}.")
      end

    end

  end

end