module Alice

  module Util
    
    class Randomizer

      def self.one_chance_in(number)
        rand(number) == 1
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
          "no treasures",
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

      def self.treasure_container
        [
          "worldy possessions include",
          "pockets contain",
          "treasures include",
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

      def self.pickup_message(item_name, actor_name)
        [
          "#{actor_name} pockets the #{item_name}.",
          "The #{item_name} now belongs to #{actor_name}!",
          "#{actor_name} now has the #{item_name}.",
          "Now #{actor_name}'s #{Alice::Treasure.container} the #{item_name}."
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

end