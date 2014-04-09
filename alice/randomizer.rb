module Alice

  class Randomizer

    def self.container
      [
        "fridge with",
        "fully stocked bar that includes",
        "six-pack with one last",
        "brown paper bag with"
      ].sample
    end
    
    def self.brew_message(item_name, actor_name)
        [
        "looks on in wonder as #{actor_name} brews a perfect #{item_name}.",
        "watches #{actor_name} whip up #{item_name}.",
        "watches #{actor_name} brew a nice #{item_name}.",
        "watches #{actor_name} brew a #{item_name}.",
        "watches as #{actor_name} makes a #{item_name}.",
        "watches #{actor_name} brew a decent #{item_name}.",
        "notices #{actor_name} brewing a #{item_name}.",
        "applauds as #{actor_name} makes a #{item_name}.",
        "nods approvingly as #{actor_name} brews a #{item_name}.",
        "admires #{actor_name}'s ability to whip up a mean #{item_name}.",
        "smiles and says, 'That's a fine #{item_name}!'",
        "admires #{actor_name}'s brewing prowess."
      ].sample
    end

    def self.drink_message(item_name, actor_name)
      [
        "#{actor_name} slams the #{item_name}.",
        "#{actor_name} sip the #{item_name}.",
        "#{actor_name} imbibes the #{item_name}.",
        "#{actor_name} gulps the #{item_name}.",
        "#{actor_name} quaffs the entire #{item_name}.",
        "#{actor_name} drains the #{item_name}.",
        "#{actor_name} consumes all of the #{item_name}."
      ].sample
    end

    def self.effect_message(item_name, actor_name)
      [
        "#{actor_name} grows bat wings and flits around the room.",
        "#{actor_name}'s head feel like it's deflating like a balloon. Time to get the bicycle pump!",
        "Drinking it all makes #{actor_name} feel a little dizzy.",
        "#{actor_name}'s heart grows three sizes.",
        "#{actor_name} achieves clarity of thought.",
        "It makes #{actor_name} want to contemplate the meaning of life.",
        "It really sobers up #{actor_name}.",
        "It makes #{actor_name} feel like burping.",
        "It gives #{actor_name} a ton of energy.",
        "It seems to drain #{actor_name}'s energy.",
        "#{actor_name} turns insubstantial.",
        "#{actor_name}'s wounds are healed!",
        "#{actor_name} feels like singing!",
        "#{actor_name} can move at double speed.",
        "#{actor_name} gains the power of invisibility.",
        "#{actor_name} gains the ability to pocket small items.",
        "#{actor_name} looks a bit ill.",
        "#{actor_name} gains immunity to all elephant-based spells.",
        "#{actor_name} feels a strong urge to travel #{Alice::Randomizer.random_direction}ward.",
        "#{actor_name} hears a strange voice calling from somewhere to the #{Alice::Randomizer.random_direction}.",
        "It seems to send a shiver down #{actor_name}'s spine.",
        "#{actor_name} is filled with the sudden urge to defy gravity.",
        "#{actor_name} tries hard not to think of flying monkeys.",
        "#{actor_name} has a sudden thirst for blood.",
        "#{actor_name} still feels strangely parched.",
        "#{actor_name} feels a sudden urge to dance."
      ].sample
    end

    def self.random_direction
      ["north", "south", "east", "west"].sample
    end

    def self.spill_message(item_name, actor_name)
      [
        "#{actor_name} spills the #{item_name} all over the floor.",
        "#{actor_name} spills the #{item_name} down the front of their shirt.",
        "#{actor_name} knocks the #{item_name} over.",
        "#{actor_name} slowly pours the #{item_name} out.",
        "#{actor_name} cries over spilled #{item_name}.",
        "The #{item_name} shatters on the floor!",
        "#{actor_name} lets out a mighty 'Whoop!' and throws the #{item_name} against a wall.",
        "#{actor_name} slyly dumps out the #{item_name}."
      ].sample
    end

  end

end