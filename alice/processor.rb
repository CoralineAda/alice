class Processor

  attr_reader :message, :user

  def initialize(message)
    @message = message
  end

  def process_command
    track_sender
    Responder.respond_to(message)
  end

  def do_greeting
    User.bot.greet(message.sender_nick)
  end

  def update_nick
    User.from_nick(message.sender_nick).update_nick(message.sender_nick)
  end

  private

  def track_sender(nick)
    self.message.sender.touch
  end

end
