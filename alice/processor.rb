class Processor

  attr_reader :message, :user

  def initialize(message)
    @message = message
  end

  def react
    track_sender
    Adapter.send_message(Responder.respond_to(message))
  end

  def greet_on_join
    track_sender
    Responder.greet(message.sender_nick)
  end

  def track_nick_change
    track_sender
    User.from_nick(message.sender_nick).update_nick(message.sender_nick)
  end

  private

  def track_sender(nick)
    self.message.sender.touch
  end

end
