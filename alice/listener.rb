require 'cinch'

class Listener

  include Cinch::Plugin

  match /(.+)/, method: :catch, use_prefix: false

  listen_to :join, method: :greet
  listen_to :nick, method: :update_nick

  def catch(emitted, trigger)
    Processor.new(Message.new(sender_nick: emitted.user.nick, trigger: trigger)).process
  end

  def greet(emitted)
    User.bot.greet(emitted.user.nick)
  end

  def update_nick(emitted)
    User.from_nick(emitted.user.nick).update_nick(emitted.user.nick)
  end

end
