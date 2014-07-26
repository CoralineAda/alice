require 'cinch'

class Listener

  include Cinch::Plugin

  match /(.+)/, method: :process, use_prefix: false

  listen_to :join, method: :greet
  listen_to :nick, method: :update_nick

  def process(emitted, trigger)
    Processor.process(message(emitted, trigger), :respond)
  end

  def greet(emitted, trigger)
    Processor.process(message(emitted, trigger), :greet_on_join)
  end

  def update_nick(emitted, trigger)
    Processor.process(message(emitted, emitted.user.last_nick), :track_nick_change)
  end

  private

  def message(emitted, trigger)
    Message.new(emitted.user.nick, trigger)
  end

end
