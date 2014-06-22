class Processor

  include PoroPlus

  attr_accessor :message, :response_method, :trigger

  def self.process(message, response_method, trigger=nil)
    new(
      message: message,
      response_method: response_method,
      trigger: trigger
    ).react
  end

  def react
    track_sender
    public_send(self.response_method)
  end

  def respond
    Response.from(self.message)
  end

  def greet_on_join
    track_sender
    Response.greeting(message)
  end

  def track_nick_change
    track_sender
    user = User.by_nick(message.sender_nick)
    user.update_nick(message.sender_nick)
    Response.name_change(message)
  end

  private

  def track_sender
    self.message.sender.touch
  end

end
