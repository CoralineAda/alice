class Response

  include PoroPlus

  attr_accessor :nick, :message

  def self.from(nick, message)
    new(nick: nick, message:message).command.response
  end

  def command
    Command.from(self)
  end

end
