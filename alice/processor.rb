require 'cinch'

class Processor

  attr_reader :message, :user

  def initialize(message)
    @message = message
  end

  def process
    track_sender
    Responder.respond_with(response)
  end

  private

  def response
    Response.from(self.message)
  end

  def track_sender(nick)
    self.message.sender.touch
  end

end
