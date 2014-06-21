class Response

  include PoroPlus

  attr_accessor :nick, :message, :type

  def self.from(nick, message)
    new(nick: nick, message:message).command.response
  end

  def command
    Command.from(self)
  end

  def is_emote?
    self.type == :emote
  end

end
