module Pipeline

  class Listener

    METHOD_MAP = {
      /^([0-9]+)/                           => :process_number,
      /(.+\+\+)$/x                          => :process_points,
      /well,* actually/i                    => :well_actually,
      /so say we all/i                      => :so_say_we_all,
      %r{(https?://.*?)(?:\s|$|,|\.\s|\.$)} => :preview_url,
      /(.+)/                                => :process_text
    }

    def route(username, trigger)
      tuple = METHOD_MAP.detect { |k,m| k.match(trigger) }
      return unless tuple.any?
      matching_method = tuple.last
      captured_match = tuple.first.match(trigger).to_s
      self.public_send(matching_method, username, captured_match)
    end

    def process_number(username, trigger)
      Pipeline::Processor.process(message(username, "13"), :respond)
    end

    def process_points(username, trigger)
      Pipeline::Processor.process(message(username, trigger), :respond)
    end

    def process_text(username, trigger)
      return unless trigger[0] =~ /[a-zA-Z\!]/x
      Pipeline::Processor.process(message(username, trigger), :respond)
    end

    def greet(username)
      return if username == Pipeline::Mediator.bot_name
      Pipeline::Processor.process(message(username, "hi"), :greet_on_join)
    end

    private

    def message(username, trigger)
      Message::Message.new(username, trigger)
    end

  end
end
