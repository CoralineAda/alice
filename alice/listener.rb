require 'cinch'

class Listener

  include Cinch::Plugin

  match /^([0-9]+)/,  method: :process_number,  use_prefix: false
  match /(.+)\+\+$/,  method: :process_points,  use_prefix: false
  match /(.+)/,       method: :process_text,    use_prefix: false
  match /well,* actually/i, method: :well_actually, use_prefix: false
  match /so say we all/i, method: :so_say_we_all, use_prefix: false
  match %r{(https?://.*?)(?:\s|$|,|\.\s|\.$)}, method: :preview_url, :use_prefix => false

  listen_to :join, method: :greet
  listen_to :nick, method: :update_nick

  def preview_url(emitted, trigger)
    Processor.process(emitted.channel, message(emitted, trigger), :preview_url)
  end

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

  def well_actually(emitted)
    Processor.process(emitted.channel, message(emitted, "well actually"), :well_actually)
  end

  def so_say_we_all(emitted)
    Processor.process(emitted.channel, message(emitted, "so say we all"), :so_say_we_all)
  end

  private

  def message(emitted, trigger)
    Message.new(emitted.user.nick, trigger)
  end

end
