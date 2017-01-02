module Message
  class Response

    attr_reader :content
    attr_accessor :response_type

    def self.greeting(message)
      message.response = Util::Randomizer.greeting(message.sender_nick)
      message
    end

    # def self.heartbeat(message)
    #   message.response = Handlers::Heartbeat.process(message, :random_act)
    #   message
    # end

    def initialize(content, response_type = "say")
      @content = content
      @response_type = response_type
    end

  end
end
