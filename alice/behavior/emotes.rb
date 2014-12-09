module Behavior

  module Emotes

    def frown_with(actor)
      [
        "frowns.",
        "agrees with #{actor}.",
        "sides with #{actor}.",
        "offers chocolate.",
        "offers a beverage.",
        "offers support.",
        "sighs.",
        "lets out a long sigh."
      ].sample
    end

    def greet(actor)
      [
        "tips a hat to",
        "nods to",
        "greets",
        "smiles at",
        "waves to",
        "hails",
        "says hi to",
        "says hello to",
        "does the o/ thing at"
      ].sample + " #{actor}."
    end

    def laugh_with(actor)
      [
        "#{Alice::Util::Randomizer.laugh} along with #{actor}.",
        "#{Alice::Util::Randomizer.laugh} at #{actor}'s antics.",
        "#{Alice::Util::Randomizer.laugh}."
      ].sample
    end

  end

end
