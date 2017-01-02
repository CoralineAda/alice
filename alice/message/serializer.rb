module Message
  class Serializer

    attr_reader :message

    def self.serialize(message)
      new(message).serialized_message
    end

    def initialize(message)
      @message = message
    end

    def serialized_message
      {
        sender: User.where(primary_nick: message.sender_nick).first,
        recipient: User.where(primary_nick: message.recipient_nick).first,
        trigger: message.trigger,
        response: message.response.content,
        context_id: Context.current.id
      }
    end

  end
end
