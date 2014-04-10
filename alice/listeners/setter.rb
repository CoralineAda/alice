require 'cinch'

module Alice

  module Listeners

    class Setter

      include Alice::Behavior::TracksActivity
      include Alice::Behavior::TracksActivity
      include Cinch::Plugin

      match /^\!bio (.+)/i,     method: :set_bio, use_prefix: false
      match /^\!fact (.+)/i,    method: :set_factoid, use_prefix: false
      match /^\!twitter (.+)/i, method: :set_twitter, use_prefix: false
      match /^FACT: (.+)/i,     method: :set_anonymous_factoid, use_prefix: false
      match /^OH: (.+)/i,       method: :set_oh, use_prefix: false

      def set_bio(channel_user, text)
        return if text == channel_user.user.nick
        text = text.gsub(/^#{channel_user.user.nick}/i, '')
        return unless text.present?
        subject = Alice::User.from(noun.downcase).last  
          subject.bio.try(:delete)
          subject.bio = Alice::Bio.create(text: text) 
          Alice::Util::Mediator.emote_to(channel_user, positive_response(channel_user.user.nick))
      end

      def set_factoid(channel_user, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          Alice::User.set_factoid(channel_user.user.nick, text)
          Alice::Util::Mediator.emote_to(channel_user, positive_response(channel_user.user.nick))
        else
          Alice::Util::Mediator.emote_to(channel_user, negative_response(channel_user.user.nick))
        end
      end

      def set_anonymous_factoid(channel_user, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          Alice::Factoid.create(text: text)
          Alice::Util::Mediator.emote_to(channel_user, positive_response(channel_user.user.nick))
        end
      end

      def set_oh(channel_user, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          Alice::Oh.create(text: text)
          Alice::Util::Mediator.emote_to(channel_user, positive_response(channel_user.user.nick))
        else
          Alice::Util::Mediator.emote_to(channel_user, negative_response(channel_user.user.nick))
        end
      end

      def set_twitter(channel_user, handle)
        Alice::User.set_twitter(channel_user.user.nick, handle)
        Alice::Util::Mediator.emote_to(channel_user, positive_response(channel_user.user.nick))
      end

      def negative_response(nick)
        Alice::Util::Randomizer.negative_request_response(nick)
      end

      def positive_response(nick)
        Alice::Util::Randomizer.positive_request_response(nick)
      end

    end

  end

end