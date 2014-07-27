class Processor

  include PoroPlus

  attr_accessor :message, :response_method, :trigger

  def self.process(message, response_method)
    new(
      message: message,
      response_method: response_method,
      trigger: message.trigger
    ).react
  end

  def react
    track_sender
    public_send(self.response_method)
  end

  def respond
    track_sender
    if response = Response.from(self.message)
      Alice::Util::Mediator.reply_with(response.response) if response.type == "message"
      Alice::Util::Mediator.emote(response.response) if response.type == "emote"
    end
  end

  def greet_on_join
    track_sender
    Alice::Util::Mediator.emote(Response.greeting(self.message).response)
  end

  def track_nick_change
    user = User.find_or_create(message.sender_nick)
    user.update_nick(message.sender_nick)
    Alice::Util::Mediator.emote(Response.name_change(self.message))
  end

  private

  def track_sender
    self.message.sender.touch
  end

end
