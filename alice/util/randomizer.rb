module Alice

  module Util
    
    class Randomizer

      def self.one_chance_in(number)
        rand(number) == 1
      end

      def self.illumination
        [
          "dark",
          "dim",
          "bright",
          "sunny",
          "foggy",
          "misty",
          "sparsely lit",
          "dimly lit",
          "lit by candles",
          "lit from an unknown source",
          "illuminated by glowing fungi on the walls",
          "illuminated by the lantern in the bored-looking wizard's hand",
          "lit by a bare bulb hanging from the ceiling",
          "dark and shadowy",
          "shadow-filled and dark",
          "tastefully lit",
          "artfully lit",
          "pitch dark",
          "filled with inky darkness",
          "distinguished by its many paper lanterns"
        ].sample
      end

      def self.thing
        [
          "a randomly generated wandering monster",
          "the remains of another adventuring party",
          "a discarded cheeseburger",
          "the remains of the day",
          "a partially eaten meat pie",
          "a dead crow",
          "several spiral-bound notebooks",
          "some unusually large boardgames",
          "the expensive decor",
          "a 20-sided die",
          "rodents of unusual size",
          "a poster of Spock",
          "the best years of your life",
          "an old deck of Pokémon cards",
          "a Cards Against Humanity game",
          "sommone else's face",
          "your entire life in pictures",
          "dark shadows",
          "a dread gazebo",
          "a flock of birds",
          "a stack of books",
          "a solitary table",
          "a deck of cards",
          "several broken dolls",
          "a creepy mannequin",
          "giant spiders",
          "miniature furniture",
          "a jewelry box",
          "a commemorative statuette of liberty",
          "an extensive DVD collection",
          "a towering wampus",
          "an old grandfather clock",
          "a picture of a duck",
          "a broken old game console",
          "random stuff",
          "tracks of the fearsome grue"
        ].sample
      end

      def self.beverage_container
        [
          "fridge with",
          "fully stocked bar that includes",
          "six-pack with one last",
          "brown paper bag with"
        ].sample
      end

      def self.dunno_response(subject)
        [
          "I don't know much about #{subject} yet."
        ].sample
      end

      def self.empty_cooler
        [
          "not a drop to drink",
          "nothing, not a single drink",
          "no drinks",
          "nothing fit to drink"
        ].sample
      end

      def self.empty_pockets
        [
          "empty pockets",
          "nothing",
          "no items",
          "nada"
          ].sample
      end

      def self.fact_prefix
        [
          "",
          "True story:",
          "I seem to recall that",
          "Rumor has it that",
          "Some believe that",
          "Some say",
          "It's been said that",
          "Legend says that",
          "According to my notes,",
          "If the rumors are to be believed,",
          "Word on the street is that"
        ].sample
      end
    
      def self.negative_response
        [
          "I would tell you if I could.",
          "I really can't talk about that.",
          "I wish I knew more about that.",
          "All I know is that the Dude abides.",
          "We don't talk about that here.",
          "No.",
          "I will not.",
          "I'm an enigma, remember?",
          "#nopenopenope"
        ].sample
      end

      
      def self.oh_prefix  
        [
          "Some say that",
          "I heard recently that",
          "Someone said that",
          "A wise person once said",
          "It's been said that"
        ].sample
      end

      def self.item_container
        [
          "worldy possessions include",
          "pockets contain",
          "items include",
          "stuff includes",
          "vast collection of rarities includes",
          "backpack conceals",
          "knapsack harbors",
          "brown paper bag with"
        ].sample
      end

      def self.drop_message(item_name, actor_name)
        [
          "The #{item_name} falls clattering to the floor.",
          "The #{item_name} is now resting on the ground.",
          "#{actor_name} drops the #{item_name}",
          "#{actor_name} discards the #{item_name}",
          "#{actor_name} drops the #{item_name} on the ground.",
          "#{actor_name} quietly places the #{item_name} on the floor.",
          "#{actor_name} puts the #{item_name} down.",
          "#{actor_name} gently puts the #{item_name} down."
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
          "#{actor_name} feels a strong urge to travel #{Alice::Util::Randomizer.random_direction}ward.",
          "#{actor_name} hears a strange voice calling from somewhere to the #{Alice::Util::Randomizer.random_direction}.",
          "It seems to send a shiver down #{actor_name}'s spine.",
          "#{actor_name} is filled with the sudden urge to defy gravity.",
          "#{actor_name} tries hard not to think of flying monkeys.",
          "#{actor_name} has a sudden thirst for blood.",
          "#{actor_name} still feels strangely parched.",
          "#{actor_name} feels a sudden urge to dance."
        ].sample
      end

      def self.hide_message(item_name, actor_name)
        [
          "#{actor_name} places the #{item_name} somewhere deep in the labyrinth.",
          "#{actor_name} hides the #{item_name} somewhere deep in the labyrinth.",
          "#{actor_name} has hidden the #{item_name}.",
          "#{actor_name} throws the #{item_name} into the dungeon.",
          "#{actor_name} hides the #{item_name}.",
          "The #{item_name} is now hidden in the depths of the labyrinth.",
          "Who will be the first to find the #{item_name}?"
        ].sample
      end

      def self.laugh
        [
          "cackles",
          "chortles",
          "chuckles",
          "giggles",
          "snickers",
          "bursts out laughing",
          "hoots",
          "howls with laughter",
          "cracks up",
          "ROFLs",
          "LOLs",
          "guffaws",
          "grins",
          "laughs",
          "snorts",
          "smiles"
        ].sample
      end

      def self.pickup_message(item_name, actor_name)
        [
          "#{actor_name} pockets the #{item_name}.",
          "The #{item_name} now belongs to #{actor_name}!",
          "#{actor_name} now has the #{item_name}.",
          "Now #{actor_name}'s #{Alice::Item.container} the #{item_name}."
        ].sample
      end

      def self.random_direction
        ["north", "south", "east", "west"].sample
      end

      def self.room_adjective
        [
          "a panelled",
          "a green",
          "a whitewashed",
          "an extravagantly furnished",
          "a smelly",
          "a decrepit",
          "a sunken",
          "a flooded",
          "a dirty",
          "a dingy",
          "a sparse",
          "a spartan",
          "an echoing",
          "an incredibly dark",
          "an incredibly large",
          "a ridiculously small",
          "a colorfully decorated",
          "a richly decorated",
          "a sparsely decorated",
          "a desolate",
          "a low-ceilinged",
          "an immense",
          "a dark",
          "a sunny",
          "a cheery",
          "a large",
          "a long",
          "a high-ceilinged",
          "a brightly-lit",
          "a small",
          "a tiny",
          "a tidy",
          "an abandoned",
          "a filthy",
          "an immaculate",
          "a",
          "a",
          "a",
          "a",
          "a",
          "a",
          "a",
          "a",
        ].sample
      end

      def self.room_description
        [
          "with a locked door on the far wall",
          "with scratches along the floor",
          "with claw marks on the wall",
          "with bare shelves lining the walls",
          "with walls covered in paintings depicting #{things}",
          "covered with posters of #{things}",
          "with a portrait of #{Alice::User.random.proper_name} on the wall",
          "dominated by a large statue of #{Alice::User.random.proper_name}",
          "with graffiti spelling out #{Alice::User.random.proper_name}'s name on the wall",
          "with what appear to be footprints on the ceiling",
          "whose floor is covered in an inch of dust",
          "with a faint smell of gunpowder",
          "with a corpse in the middle of the room",
          "with a massive church organ against one wall",
          "containing #{things}",
          "housing #{things}",
          "containing #{things} and #{things}",
          "servng as a storage room for #{things}",
          "with walls papered in intricate yellow designs",
          "with crumbling walls",
          "with a drooping ceiling",
          "with broken furniture scattered throughout",
          "with #{things} on the floor",
          "with high shelves",
          "overrun with rats",
          "swarming with centipedes",
          "carpeted in deep red plush",
          "lit by candles",
          "lit by a large chandelier",
          "without any windows",
          "with tall windows",
          "shaped like a pentagon",
          "shaped like an octagon",
          "reminiscent of a hospital room",
          "with a hospital bed",
          "that is definitely not trapped",
          "that is home to a sleeping bear",
          "whose walls are discolored",
          "lit from an unknown source",
          "lined with bookshelves",
          "that stands empty",
          "with a window through which you can see #{things}",
          "partially in ruin",
          "decorated with #{things}",
          "with walls that look like they were painted by #{things}",
          "in which #{things} lies sleeping",
          "filled with #{things} you remember so well from your childhood",
          "your great-aunt's famous dish, #{things}",
          "echoing with hollow laughter",
          "with walls coated in flaking red paint",
          "with a strange insignia painted on the wall",
          "with a large chalk circle on the floor",
          "with a pentagram drawn in chalk on the floor",
          "littered with discarded papers",
          "littered with the remains of a hastily-consumed meal"
        ].sample
      end

      def self.room_type
        [
          "brewery",
          "cavern",
          "cave",
          "randomly generated room",
          "cul-de-sac",
          "tunnel",
          "room",
          "chamber",
          "kitchen",
          "bathroom",
          "hallway",
          "great hall",
          "dining room",
          "auditorium",
          "dressing room",
          "theatre",
          "storeroom",
          "room",
          "tardis",
          "bed chamber",
          "vault",
          "corridor",
          "lair",
          "pit"
        ].sample
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

end