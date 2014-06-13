require 'cinch'

module Alice

  module Listeners

    class Score

      include Cinch::Plugin

      match /\!score$/i,          method: :my_score, use_prefix: false
      match /\!score (.+)/i,      method: :player_score, use_prefix: false
      match /\!scores/i,          method: :scores, use_prefix: false
      match /\!award (.+)/i,      method: :award, use_prefix: false
      match /^(.+)\+\+/,         method: :award, use_prefix: false

      def award(channel_user, player)
        return unless actor = User.find_or_create(player) || Actor.from(player).first
        current_user = current_user_from(channel_user)
        if actor == current_user
          Alice::Util::Mediator.reply_to(channel_user, "#{current_user.proper_name} is gonna make themselves go blind that way.")
        elsif current_user.can_award_points?
          current_user.award_point_to(actor)
          Alice::Util::Mediator.reply_to(channel_user, actor.check_score)
        else
          Alice::Util::Mediator.reply_to(channel_user, "#{current_user.proper_name} can't go giving out points all day long.")
        end
      end

      def my_score(channel_user)
        current_user = User.with_nick_like(channel_user.user.nick)
        Alice::Util::Mediator.reply_to(channel_user, user.check_score)
      end

      def pants(channel_user)
        if observer == User.bot
          Alice::Util::Mediator.emote_to(channel_user, "#{observer.laugh_with(channel_user.user.nick)}")
        else
          Alice::Util::Mediator.reply_to(channel_user, "#{observer.proper_name} #{observer.laugh_with(channel_user.user.nick)}")
        end
      end

      def player_score(channel_user, player)
        if actor = User.from(player).first || Actor.from(player).first
          Alice::Util::Mediator.reply_to(channel_user, actor.check_score)
        else
          Alice::Util::Mediator.reply_to(channel_user, "#{player} isn't even playing the game.")
        end
      end

      def scores(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, Alice::Leaderboard.report)
      end

    end

  end

end
