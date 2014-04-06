require 'cinch'

module Alice

  class Core

    include Cinch::Plugin

    match /[hi|hello|] alicebot/i, method: :greet, use_prefix: false
    match /\!cookie (.+)/, method: :cookie, use_prefix: false

    def greet(m)
      m.action_reply "greets fellow hacker #{m.user.nick}."
    end

    def cookie(m, who)
      m.action_reply "gives #{who} a cookie."
    end

    def sender_is_self?(sender, who)
      sender.user.nick == who
    end

  end

end
