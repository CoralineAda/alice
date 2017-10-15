module Pipeline

  class Listener

    attr_reader :username, :trigger

    METHOD_MAP = {
      /^[0-9]+/                             => :process_number,
      /(.+\+\+)/x                           => :process_points,
      /(.+)/                                => :process_text
    }

    def initialize(username, trigger)
      @username = username
      @trigger = trigger
    end

    def route
      return unless tuple = METHOD_MAP.find{ |k,m| k.match(trigger) }
      matching_method = tuple.last
      captured_match = tuple.first.match(trigger).to_s
      self.public_send(matching_method)
    end

    def process_number
      Pipeline::Processor.process(message("!13"), :respond)
    end

    def process_kindness
      Pipeline::Processor.process(message("nice"), :respond)
    end

    def process_points
      Pipeline::Processor.process(message(self.trigger), :respond)
    end

    def process_text
      return unless self.trigger[0] =~ /[a-zA-Z\!]/x
      message = Pipeline::Processor.process(message(self.trigger), :respond)
      if message.response.nil? || message.response.content.empty? && self.trigger =~ /nice|good|kind|sweet|cool|great/i
        message = Pipeline::Processor.process(message("nice"), :respond)
      end
      message
    end

    private

    def message(content)
      Message::Message.new(self.username, content.gsub('@', ''))
    end

  end
end
