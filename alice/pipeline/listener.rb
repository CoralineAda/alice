module Pipeline

  class Listener

    METHOD_MAP = {
      /^[0-9]+/                             => :process_number,
      /(.+\+\+)/x                           => :process_points,
      /(.+)/                                => :process_text
    }

    def route(username, trigger)
      tuple = METHOD_MAP.find{ |k,m| k.match(trigger) }
      Alice::Util::Logger.info "*** tuple = #{tuple}"
      return unless tuple
      matching_method = tuple.last
      captured_match = tuple.first.match(trigger).to_s
      self.public_send(matching_method, username, captured_match)
    end

    def process_number(username, trigger)
      Alice::Util::Logger.info "*** processing number"
      Pipeline::Processor.process(message(username, "!13"), :respond)
    end

    def process_points(username, trigger)
      Pipeline::Processor.process(message(username, trigger), :respond)
    end

    def process_text(username, trigger)
      return unless trigger[0] =~ /[a-zA-Z\!]/x
      Pipeline::Processor.process(message(username, trigger), :respond)
    end

    private

    def message(username, trigger)
      Message::Message.new(username, trigger)
    end

  end
end
