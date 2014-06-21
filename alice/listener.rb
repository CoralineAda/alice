require 'cinch'

class Listener

  include Cinch::Plugin

  match /(.+)/, method: :catch, use_prefix: false

  listen_to :join, method: :greet
  listen_to :nick, method: :update_nick

  def catch(emitted, trigger)
    Processor.new(message(emitted, trigger)).react
  end

  def greet(emitted)
    Processor.new(message(emitted, :join)).do_greeting
  end

  def update_nick(emitted)
    Processor.new(message(emitted, :nick)).update_nick
  end

  private

  def message(emitted, trigger)
    Message.new(sender_nick: emitted.user.nick, trigger: trigger)
  end

end
