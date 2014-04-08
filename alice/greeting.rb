module Alice

  class Greeting
    
    def self.random(name)
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
      ].sample + " #{name}."
    end

  end

end