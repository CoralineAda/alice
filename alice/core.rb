require 'cinch'

module Alice

  class Core

    include Cinch::Plugin

    match /[hi|hello|] alicebot/i, method: :greet, use_prefix: false
    match /\!cookie (.+)/, method: :cookie, use_prefix: false
    match /\!fruitcake (.+)/, method: :fruitcake, use_prefix: false
    match /\!pants/, method: :pants, use_prefix: false
    match /\!help/, method: :help, use_prefix: false

    def greet(m)
      m.action_reply "greets fellow hacker #{m.user.nick}."
    end

    def cookie(m, who)
      m.action_reply "gives #{who} a cookie."
    end

    def fruitcake(m, who)
      giver = Alice::User.find_or_create(m.user.nick)
      recipient = Alice::User.where(primary_nick: who.downcase).first
      m.reply("Nice try, #{m.user.nick}.") and return unless recipient
      if giver.has_fruitcake?
        m.action_reply "passes the fruitcake from #{m.user.nick} to #{who}."
        giver.update_attribute(:has_fruitcake, false)
        recipient.update_attribute(:has_fruitcake, true)
      else
        if user = Alice::User.where(has_fruitcake: true).first
          m.reply("Only #{user.primary_nick} can pass the sacred fruitcake.")
        else
          m.reply("The sacred fruitcake is lost to us!")
        end
      end
    end

    def pants(m)
      m.action_reply "giggles."
    end

    def help(m)
      m.reply("!bio sets your bio, !fact sets a fact about yoursef.")
      m.reply("Learn more about your fellow hackers by asking who they are or for me to tell you about them.")
      m.reply("I know lots of stuff. Use !facts to prove it.")
    end

    def sender_is_self?(sender, who)
      sender.user.nick == who
    end

  end

end
