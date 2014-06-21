class Processor

  attr_reader :message, :user

  def initialize(message)
    @message = message
  end

  def react
    track_sender
    Responder.respond_to(message)
  end

  def greet_on_join
    Responder.greet(message.sender_nick)
  end

  def track_nick_change
    User.from_nick(message.sender_nick).update_nick(message.sender_nick)
  end

  private

  def track_sender(nick)
    self.message.sender.touch
  end

end
