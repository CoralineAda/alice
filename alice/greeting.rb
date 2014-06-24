class Greeting

  def self.greet(message)
    Alice::Util::Randomizer.greeting(message.sender_nick)
  end

end