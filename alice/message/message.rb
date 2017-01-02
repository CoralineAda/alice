module Message
  class Message

    attr_accessor :sender_nick, :recipient_nick, :type, :trigger
    attr_reader :response

    delegate :response_type, to: :response
    delegate :response_type=, to: :response

    def initialize(sender_nick, trigger)
      @sender_nick = sender_nick
      @trigger = trigger
      @response = Response.new("")
    end

    def content
      self.trigger
    end

    def is_sudo?
      Pipeline::Mediator.op?(self.sender_nick)
    end

    def recipient
      @recipient ||= User.find_or_create(self.recipient_nick)
    end

    def sender
      return unless self.sender_nick
      @sender ||= User.find_or_create(self.sender_nick)
    end

    def response=(content)
      @response = Response.new(content)
    end

  end
end
