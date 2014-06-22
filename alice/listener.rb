require 'cinch'

class Listener

  include Cinch::Plugin

  match /(.+)/, method: :process, use_prefix: false
  listen_to :join, method: :greet
  listen_to :nick, method: :update_nick

  def process(emitted, trigger)
    Processor.process(message(emitted, trigger), :respond, trigger)
  end

  def greet(emitted)
    Processor.process(message(emitted, trigger), :greet_on_join)
    #processor(emitted, :join).greet_on_join
  end

  def update_nick(emitted)
    Processor.process(message(emitted, trigger), :update_nick)
#    processor(emitted, :update_nick).track_nick_change
  end

  private

  def message(emitted, trigger)
    Message.new(sender_nick: emitted.user.nick, trigger: trigger)
  end

end
