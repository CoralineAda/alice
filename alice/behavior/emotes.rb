module Alice

  module Behavior
  
    module Emotes

      def observe_brewing(item, actor)
        [
          "looks on in wonder as #{actor} brews a perfect #{item}.",
          "watches #{actor} whip up #{item}.",
          "watches #{actor} brew a nice #{item}.",
          "watches #{actor} brew a #{item}.",
          "watches as #{actor} makes a #{item}.",
          "watches #{actor} brew a decent #{item}.",
          "notices #{actor} brewing a #{item}.",
          "applauds as #{actor} makes a #{item}.",
          "nods approvingly as #{actor} brews a #{item}.",
          "admires #{actor}'s ability to whip up a mean #{item}.",
          "smiles and says, 'That's a fine #{item}!'",
          "admires #{actor}'s brewing prowess."
        ].sample
      end

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

end