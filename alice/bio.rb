require 'cinch'

module Alice

  class Bio

    include Cinch::Plugin

    match /^\!bio (.+)/, method: :set_bio, use_prefix: false
    match /^\!fact (.+)/, method: :set_factoid, use_prefix: false
    match /!facts/, method: :random_fact, use_prefix: false
    match /^who is ([A-Za-z0-9\_]+)[!|.|\?]?$/i, method: :get_bio, use_prefix: false
    match /^tell me .+?([A-Za-z0-9\_]+)[!|.|\?]?$/i, method: :get_factoid, use_prefix: false

    def set_bio(m, text)
      Alice::User.set_bio(m.user.nick, text)
      m.action_reply("nods.")
    end

    def get_bio(m, who)
      if bio = Alice::User.get_bio(who)
        m.reply "#{who} is #{bio}.#{twitter_}"
      end
    end

    def set_factoid(m, text)
      Alice::User.set_factoid(m.user.nick, text)
      m.action_reply("makes a note.")
    end

    def get_factoid(m, who)
      factoid = Alice::User.get_factoid(who) 
      factoid && m.reply(factoid)
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
