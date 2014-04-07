require 'cinch'

module Alice

  module Listeners

    class Setter

      include Cinch::Plugin

      match /^\!bio (.+)/, method: :set_bio, use_prefix: false
      match /^\!fact (.+)/, method: :set_factoid, use_prefix: false
      match /^\!twitter (.+)/, method: :set_twitter, use_prefix: false
      match /^FACT: (.+)/, method: :set_anonymous_factoid, use_prefix: false
      match /^OH: (.+)/, method: :set_oh, use_prefix: false

      def set_bio(m, text)
        Alice::User.set_bio(m.user.nick, text)
        m.action_reply("nods.")
      end

      def set_factoid(m, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          Alice::User.set_factoid(m.user.nick, text)
          m.action_reply(positive_memorization_response(m.user.nick))
        else
          m.action_reply(negative_memorization_response(m.user.nick))
        end
      end

      def set_anonymous_factoid(m, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          Alice::Factoid.create(text: text)
          m.action_reply(positive_memorization_response(m.user.nick))
        end
      end

      def set_oh(m, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          Alice::Oh.create(text: text)
          m.action_reply(positive_memorization_response(m.user.nick))
        else
          m.action_reply(negative_memorization_response(m.user.nick))
        end
      end

      def set_twitter(m, handle)
        Alice::User.set_twitter(m.user.nick, handle)
        m.action_reply(positive_memorization_response(m.user.nick))
      end

      def negative_memorization_response(nick)
        [
          "calls bs on #{nick}.",
          "stares blanklu at #{nick}",
          "shakes her head at #{nick}",
          "refuses to listen to #{nick} anymore.",
          "snaps her eyes shut and shakes her head."
        ].sample
      end

      def positive_memorization_response(nick)
        [
          "listens carefully and nods to herself.",
          "googles to verify that.",
          "makes a mental note.",
          "grins and winks at #{nick}.",
          "nods sagely.",
          "stares fixedly at #{nick}."
          "commits that to memory.",
          "will remember that, #{nick}.",
          "thinks that should go on the Twitters.",
          "suspects that soneone will tweet about that.",
          "remembers something about that from earlier."
        ].sample
      end

    end

  end

end