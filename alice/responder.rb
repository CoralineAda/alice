class Responder

  attr_accessor :message

  def self.respond_to(message)
    new(message).respond
  end

  def initialize(message)
    @message = message
  end

  def respond
    respond_with_emote if message.is_emote?
    respond_with_reply
  end

  private

  def respond_with_emote
    Adapter.emote_to(message.sender_nick, response)
  end

  def respond_with_reply
    Adapter.reply_to(message.sender_nick, response)
  end

  def response
    Response.from(self.message)
  end

end
