module Pipeline

  class Listener

    METHOD_MAP = {
      /^[0-9]+/                             => :process_number,
      /(.+\+\+)/x                           => :process_points,
      /(.+)/                                => :process_text
    }

    def route(username, trigger)
      return unless tuple = METHOD_MAP.find{ |k,m| k.match(trigger) }
      matching_method = tuple.last
      captured_match = tuple.first.match(trigger).to_s
      self.public_send(matching_method, username, captured_match)
    end

    def process_number(username, trigger)
      Pipeline::Processor.process(message(username, "!13"), :respond)
    end

    def process_kindness(username, trigger)
      Pipeline::Processor.process(message(username, "nice"), :respond)
    end

    def process_points(username, trigger)
      Pipeline::Processor.process(message(username, trigger), :respond)
    end

    def process_text(username, trigger)
      return unless trigger[0] =~ /[a-zA-Z\!]/x
      message = Pipeline::Processor.process(message(username, trigger.gsub('@', '')), :respond)
      if message.response.content.empty? && trigger =~ /nice|good|kind|sweet|cool|great/i
        message = Pipeline::Processor.process(message(username, "nice"), :respond)
      end
      message
    end

    private

    def message(username, trigger)
      Message::Message.new(username, trigger)
    end

  end
end
