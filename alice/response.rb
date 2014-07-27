class Response

  attr_accessor :message

  def self.from(message)
    Command.process(message)
  end

  def self.name_change(message)
    message.response = "notes the name change."
    message
  end

  def self.greeting(message)
    message.response = Alice::Util::Randomizer.greeting(message.sender_nick)
    message
  end

end
