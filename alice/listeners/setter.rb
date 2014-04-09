require 'cinch'

module Alice

  module Listeners

    class Setter

      include Alice::Behavior::TracksActivity
      include Alice::Behavior::TracksActivity
      include Cinch::Plugin

      match /^\!bio (.+)/, method: :set_bio, use_prefix: false
      match /^\!fact (.+)/, method: :set_factoid, use_prefix: false
      match /^\!twitter (.+)/, method: :set_twitter, use_prefix: false
      match /^FACT: (.+)/, method: :set_anonymous_factoid, use_prefix: false
      match /^OH: (.+)/, method: :set_oh, use_prefix: false

      def set_bio(channel_user, text)
        return if text == channel_user.user.nick
        text = text.gsub(/^#{channel_user.user.nick}/i, '')
        return unless text.present?
        Alice::User.set_bio(channel_user.user.nick, text) 
        Alice::Util::Mediator.emote_to(channel_user, positive_memorization_response(channel_user.user.nick))
      end

      def set_factoid(channel_user, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          Alice::User.set_factoid(channel_user.user.nick, text)
          Alice::Util::Mediator.emote_to(channel_user, positive_memorization_response(channel_user.user.nick))
        else
          Alice::Util::Mediator.emote_to(channel_user, negative_memorization_response(channel_user.user.nick))
        end
      end

      def set_anonymous_factoid(channel_user, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          Alice::Factoid.create(text: text)
          Alice::Util::Mediator.emote_to(channel_user, positive_memorization_response(channel_user.user.nick))
        end
      end

      def set_oh(channel_user, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          Alice::Oh.create(text: text)
          Alice::Util::Mediator.emote_to(channel_user, positive_memorization_response(channel_user.user.nick))
        else
          Alice::Util::Mediator.emote_to(channel_user, negative_memorization_response(channel_user.user.nick))
        end
      end

      def set_twitter(channel_user, handle)
        Alice::User.set_twitter(channel_user.user.nick, handle)
        Alice::Util::Mediator.emote_to(channel_user, positive_memorization_response(channel_user.user.nick))
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
          "nods at #{nick}.",
          "stares fixedly at #{nick}.",
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