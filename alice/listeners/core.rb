require 'cinch'

module Alice

  module Listeners

    class Core

      include Alice::Behavior::Listens
      include Alice::Behavior::TracksActivity
      include Cinch::Plugin

      match /\!cookie (.+)/i,     method: :cookie, use_prefix: false
      match /\!pants/i,           method: :pants, use_prefix: false
      match /\!help/i,            method: :help, use_prefix: false
      match /\!score$/i,          method: :my_score, use_prefix: false
      match /\!score (.+)/i,      method: :player_score, use_prefix: false
      match /\!scores/i,          method: :scores, use_prefix: false
      match /\<\.\</,             method: :shifty_eyes, use_prefix: false
      match /\>\.\>/,             method: :shifty_eyes, use_prefix: false
      match /rule[s]? them all/i, method: :bind_them, use_prefix: false
      match /say we all/i,        method: :say_we_all, use_prefix: false

      listen_to :nick, method: :update_nick
      listen_to :join, method: :maybe_say_hi

      def bind_them(channel_user)
        Alice::Util::Mediator.emote_to(channel_user, "whispers, 'And in the darkness bind() them.'")
      end

      def cookie(channel_user, who)
        return unless Alice::User.find_or_create(who)
        Alice::Util::Mediator.emote_to(channel_user, "tempts #{channel_user.user.nick} with a warm cookie.")
      end

      def frown(channel_user)
        return unless Alice::Util::Randomizer::one_chance_in(5)
        if observer == Alice::User.bot
          Alice::Util::Mediator.emote_to(channel_user, "#{observer.frown_with(channel_user.user.nick)}")
        else
          Alice::Util::Mediator.reply_to(channel_user, "#{observer.proper_name} #{observer.frown_with(channel_user.user.nick)}")
        end
      end

      def help(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, "For most things you can tell me or ask me something in plain English.")
        Alice::Util::Mediator.reply_to(channel_user, "!bio sets your bio, !fact sets a fact about yoursef, !twitter sets your Twitter handle.")
        Alice::Util::Mediator.reply_to(channel_user, "!inventory, !forge, !brew, and !look can come in handy sometimes.")
        Alice::Util::Mediator.reply_to(channel_user, "Also: beware the fruitcake.")
      end

      def laugh(channel_user)
        return unless Alice::Util::Randomizer.one_chance_in(10)
        if observer == Alice::User.bot
          Alice::Util::Mediator.emote_to(channel_user, "#{observer.laugh_with(channel_user.user.nick)}")
        else
          Alice::Util::Mediator.reply_to(channel_user, "#{observer.proper_name} #{actor.laugh_with(channel_user.user.nick)}")
        end
      end

      def maybe_say_hi(channel_user)
        return if Alice::Util::Mediator.is_bot?(channel_user.user.nick)
        return unless Alice::Util::Randomizer.one_chance_in(10)
        Alice::Util::Mediator.emote_to(channel_user, Alice::Util::Randomizer.greeting(channel_user.user.nick))
      end

      def my_score(channel_user)
        user = Alice::User.like(channel_user.user.nick)
        Alice::Util::Mediator.reply_to(channel_user, user.check_score)
      end

      def pants(channel_user)
        if observer == Alice::User.bot
          Alice::Util::Mediator.emote_to(channel_user, "#{observer.laugh_with(channel_user.user.nick)}")
        else
          Alice::Util::Mediator.reply_to(channel_user, "#{observer.proper_name} #{observer.laugh_with(channel_user.user.nick)}")
        end
      end

      def player_score(channel_user, player)
        if actor = Alice::User.from(player).first || Alice::Actor.from(player).first
          Alice::Util::Mediator.reply_to(channel_user, actor.check_score)
        else
          Alice::Util::Mediator.reply_to(channel_user, "#{player} isn't even playing the game.")
        end
      end

      def say_we_all(channel_user)
        Alice::Util::Mediator.emote_to(channel_user, "solemny says, 'So say we all.'")
      end

      def scores(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, Alice::Leaderboard.report)
      end

      def shifty_eyes(channel_user)
        return unless Alice::Util::Randomizer::one_chance_in(3)
        Alice::Util::Mediator.emote_to(channel_user, "thinks #{channel_user.user.nick} looks pretty shifty.")
      end


      def update_nick(channel_user)
        Alice::User.update_nick(channel_user.user.nick, channel_user.user.last_nick)
      end

    end

  end

end
