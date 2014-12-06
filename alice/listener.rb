require 'cinch'

class Listener

  include Cinch::Plugin

  METHOD_MAP = {
    /^([0-9]+)/                           => :process_number,
    /(.+\+\+)$/x                          => :process_points,
    /well,* actually/i                    => :well_actually,
    /so say we all/i                      => :so_say_we_all,
    %r{(https?://.*?)(?:\s|$|,|\.\s|\.$)} => :preview_url,
    /(.+)/                                => :process_text
  }

  match /(.+)/, method: :route, use_prefix: false
  listen_to :nick, method: :nick_update
  listen_to :join, method: :greet

  def route(emitted, trigger)
    return unless to_call = METHOD_MAP.detect { |k,m| k.match(trigger) }.last
    self.public_send(to_call, emitted, trigger)
  end

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

  def nick_update(emitted)
    old_name = emitted.prefix.split("!")[0]
    processor = Processor.process(emitted.channel || ENV['PRIMARY_CHANNEL'], message(emitted, emitted.params.first, old_name), :track_nick_change)
  end

  def well_actually(emitted)
    Processor.process(emitted.channel, message(emitted, "well actually"), :well_actually)
  end

  def so_say_we_all(emitted)
    Processor.process(emitted.channel, message(emitted, "so say we all"), :so_say_we_all)
  end

  private

  def message(emitted, trigger, user=nil)
    Message.new(user || emitted.user.nick, trigger)
  end

end
