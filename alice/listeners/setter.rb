require 'cinch'

module Alice

  module Listeners

    class Setter

      include Alice::Behavior::TracksActivity
      include Alice::Behavior::Listens
      include Cinch::Plugin

      match /^\!bio (.+)/i,     method: :set_bio, use_prefix: false
      match /^\!fact (.+)/i,    method: :set_factoid, use_prefix: false
      match /^\!twitter (.+)/i, method: :set_twitter, use_prefix: false
      match /^\!oh (.+)/i,      method: :set_oh, use_prefix: false
      match /^FACT: (.+)/i,     method: :set_factoid, use_prefix: false
      match /^OH: (.+)/i,       method: :set_oh, use_prefix: false

      def set_bio(channel_user, text)
        return if text == channel_user.user.nick
        text = text.gsub(/^#{channel_user.user.nick}/i, '')
        return unless text.present?
        current_user = current_user_from(channel_user)
        current_user.bio.try(:delete)
        current_user.bio = Alice::Bio.create(text: text)
        Alice::Util::Mediator.emote_to(channel_user, positive_response(channel_user.user.nick))
      end

      def set_factoid(channel_user, text)
        return unless text.size > 0
        if text.split(' ').count > 1
          current_user = current_user_from(channel_user)
          if text =~ /^I /i
            current_user.factoids.create(text: text)
          else
            Alice::Factoid.create(text: text)
          end
          Alice::Util::Mediator.emote_to(channel_user, positive_response(channel_user.user.nick))
        else
          Alice::Util::Mediator.emote_to(channel_user, negative_response(channel_user.user.nick))
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
        current_user = current_user_from(channel_user)
        current_user.update_attribute(:twitter_handle, handle)
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