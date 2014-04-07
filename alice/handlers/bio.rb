require 'cinch'

module Alice

  module Handlers

    class Bio

      include Cinch::Plugin

      match /^\!bio (.+)/, method: :set_bio, use_prefix: false
      match /^\!fact (.+)/, method: :set_factoid, use_prefix: false
      match /^\!twitter (.+)/, method: :set_twitter, use_prefix: false
      match /!facts/, method: :random_fact, use_prefix: false
      match /^who is ([A-Za-z0-9\_]+)[!|.|\?]?$/i, method: :get_bio, use_prefix: false
      match /^tell me .+?([A-Za-z0-9\_]+)[!|.|\?]?$/i, method: :get_factoid, use_prefix: false
      match /^who[\'s|s| is]+ ([A-Za-z0-9\_]+) on twitter[!|.|\?]?$/i, method: :get_twitter, use_prefix: false
      match /^what is ([A-Za-z0-9\_]+)'s twitter handle[!|.|\?]?$/i, method: :get_twitter, use_prefix: false
      match /^what is ([A-Za-z0-9\_]+)'s twitter[!|.|\?]?$/i, method: :get_twitter, use_prefix: false

      def set_bio(m, text)
        Alice::User.set_bio(m.user.nick, text)
        m.action_reply("nods.")
      end

      def get_bio(m, who)
        return unless user = Alice::User.like(who)
        return unless bio = Alice::User.get_bio(who)
        name = who.capitalize == user.formatted_name ? user.formatted_name : "#{user.formatted_name}, aka #{who.capitalize},"
        m.reply "#{name} is #{bio}"
      end

      def set_factoid(m, text)
        if text.split(' ').count > 1
          Alice::User.set_factoid(m.user.nick, text)
          m.action_reply("makes a note.")
        else
          m.action_reply("calls BS on #{m.user.nick}.")
        end
      end

      def set_twitter(m, handle)
        Alice::User.set_twitter(m.user.nick, handle)
        m.action_reply("considers following #{handle}.")
      end

      def get_factoid(m, who)
        factoid = Alice::User.get_factoid(who) 
        factoid && m.reply(factoid)
      end

      def get_twitter(m, who)
        user = Alice::User.like(who)
        user && user.twitter_handle && m.reply("#{who} is #{user.twitter_handle} on Twitter (#{user.twitter_url})")
      end

      def random_fact(m)
        factoid = Alice::Factoid.random
        factoid && m.reply(factoid.formatted)
      end

      def clear_bio(m, who)
        if sender_is_self?(who)
          Alice::User.clear_bio(who)
          m.reply("Bio for #{who} removed. Set it again using '!bio set <nick> <bio>'")
        else
          m.reply("You can't clear someone else's bio, sorry.")
        end        
      end
      
    end

  end

end