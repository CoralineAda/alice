require 'cinch'

class Listener

  include Cinch::Plugin

  match /^([0-9]+)/,  method: :process_number,  use_prefix: false
  match /(.+)\+\+$/,  method: :process_points,  use_prefix: false
  match /(.+)/,       method: :process_text,    use_prefix: false

  listen_to :join, method: :greet
  listen_to :nick, method: :update_nick

  def process_number(emitted, trigger)
    Processor.process(emitted.channel, message(emitted, "13"), :respond)
  end

  def process_points(emitted, trigger)
    Processor.process(emitted.channel, message(emitted, trigger), :respond)
  end

  def process_text(emitted, trigger)
    return unless trigger[0] =~ /[a-zA-Z\!]/
    Processor.process(emitted.channel, message(emitted, trigger), :respond)
  end

  def greet(emitted)
    return if emitted.user.nick == Alice::Util::Mediator.bot_name
    Processor.process(emitted.channel, message(emitted, emitted.user.nick), :greet_on_join)
  end

  def update_nick(emitted)
    Processor.process(emitted.channel, message(emitted, emitted.user.last_nick), :track_nick_change)
  end

  private

  def message(emitted, trigger)
    Message.new(emitted.user.nick, trigger)
  end

end
