class Response

  attr_accessor :message

  def self.from(message)
    Command.process(message)
  end

  def self.name_change(message)
  end

  def self.greeting(message)
    Alice::Util::Randomizer.greeting(message.sender_nick)
  end

end
