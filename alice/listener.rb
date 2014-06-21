require 'cinch'

class Listener

  include Cinch::Plugin

  match /(.+)/, method: :process, use_prefix: false

  listen_to :join, method: :greet
  listen_to :nick, method: :update_nick

  def processor(emitted, trigger)
    Processor.new(message(emitted, trigger))
  end

  def process(emitted, trigger)
    processor(emitted, trigger).react
  end

  def greet(emitted)
    processor(emitted, :join).greet_on_join
  end

  def update_nick(emitted)
    processor(emitted, :update_nick).track_nick_change
  end

  private

  def message(emitted, trigger)
    Message.new(sender_nick: emitted.user.nick, trigger: trigger)
  end

end
