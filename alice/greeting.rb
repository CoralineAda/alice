class Alice::Greeting

  def self.process(recipient, command)
    Alice::Response.new(content: random(recipient), kind: :action)
  end

  def self.random(name)
    "#{greetings.sample} #{name}."
  end

  def self.greetings
    [
      "tips her hat to",
      "nods to",
      "greets",
      "smiles at",
      "waves to",
      "hails",
      "says hi to",
      "says hello to",
      "greets fellow hacker",
      "does the o/ thing at"
    ]
  end

end