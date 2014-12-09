require 'cinch'

module Pipeline

  class Listener

    include ::Cinch::Plugin

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
    listen_to :ping, method: :heartbeat

    def route(emitted, trigger)
      tuple = METHOD_MAP.detect { |k,m| k.match(trigger) }
      return unless tuple.any?
      matching_method = tuple.last
      captured_match = tuple.first.match(trigger).to_s
      self.public_send(matching_method, emitted, captured_match)
    end

    def heartbeat(emitted)
      Pipeline::Processor.process(emitted.channel, message(emitted, "ping", User.bot), :heartbeat)
    end

    def preview_url(emitted, trigger)
      Pipeline::Processor.process(emitted.channel, message(emitted, trigger), :preview_url)
    end

    def process_number(emitted, trigger)
      Pipeline::Processor.process(emitted.channel, message(emitted, "13"), :respond)
    end

    def process_points(emitted, trigger)
      Pipeline::Processor.process(emitted.channel, message(emitted, trigger), :respond)
    end

    def process_text(emitted, trigger)
      return unless trigger[0] =~ /[a-zA-Z\!]/x
      Pipeline::Processor.process(emitted.channel, message(emitted, trigger), :respond)
    end

    def greet(emitted)
      return if emitted.user.nick == Pipeline::Mediator.bot_name
      Pipeline::Processor.process(emitted.channel, message(emitted, emitted.user.nick), :greet_on_join)
    end

    def nick_update(emitted)
      old_name = emitted.prefix.split("!")[0]
      processor = Pipeline::Processor.process(emitted.channel || ENV['PRIMARY_CHANNEL'], message(emitted, emitted.params.first, old_name), :track_nick_change)
    end

    def well_actually(emitted)
      Pipeline::Processor.process(emitted.channel, message(emitted, "well actually"), :well_actually)
    end

    def so_say_we_all(emitted)
      Pipeline::Processor.process(emitted.channel, message(emitted, "so say we all"), :so_say_we_all)
    end

    private

    def message(emitted, trigger, user=nil)
      Message::Message.new(user || emitted.user.nick, trigger)
    end

  end
end
