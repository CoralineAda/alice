module Message
  class Message

    attr_accessor :sender_nick, :recipient_nick, :type, :trigger, :response_type, :response

    def initialize(sender_nick, trigger)
      self.sender_nick = sender_nick
      self.trigger = trigger
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

    def set_response(content)
      self.response = content
      self
    end

  end
end