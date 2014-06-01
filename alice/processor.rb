require 'cinch'

class Processor

  include Cinch::Plugin

  attr_accessor :nick, :message

  match /(.+)/, method: :catch, use_prefix: false

  def catch(emitted, message)
    self.nick = emitted.user.nick
    self.message = message
    track && respond
  end

  private

  def respond
    Alice::Util::Mediator.reply_to(nick).with(response).do
  end

  def response
    Response.from(self)
  end

  def track
    Alice::User.track(nick)
  end

end
