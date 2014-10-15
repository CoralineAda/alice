require 'pry'
class Processor

  include PoroPlus

  attr_accessor :channel, :message, :response_method, :trigger

  def self.process(channel, message, response_method)
    new(
      channel: channel,
      message: message,
      response_method: response_method,
      trigger: message.trigger
    ).react
  end

  def react
    track_sender
    public_send(self.response_method) if should_respond?
  end

  def should_respond?
    return true if self.trigger[0] == "!"
    return true if self.trigger =~ /\+\+/
    return true if self.trigger =~ /^[0-9\.\-]+$/
    return true if self.trigger =~ /#{ENV['BOT_SHORT_NAME']}/i
    return true if self.response_method == :greet_on_join
    false
  end

  def respond
    track_sender
    if response = self.message.response
      if self.message.response_type == "emote"
        Alice::Util::Mediator.emote(self.channel, response)
      else
        Alice::Util::Mediator.reply_with(self.channel, response)
      end
    end
    message
  end

  def greet_on_join
    track_sender
    return unless Alice::Util::Randomizer.one_chance_in(4)
    Alice::Util::Mediator.emote(
      self.channel,
      Response.greeting(self.message).response
    )
    message
  end

  def track_nick_change
    user = User.find_or_create(message.sender_nick)
    user.update_nick(message.sender_nick)
    Alice::Util::Mediator.emote(
      self.channel,
      Response.name_change(self.message).response
    )
    message
  end

  private

  def track_sender
    self.message.sender.touch
  end

end
