module Alice

  module Util
    
    class Randomizer

      def self.one_chance_in(number)
        rand(number - 1) == 1
      end

      def self.action
        [
          "lurking nearby.",
          "hiding behind the door.",
          "whispering softly.",
          "hissing like a snake.",
          "standing around listlessly.",
          "playing a quiet came of Chutes and Ladders.",
          "pretending to read a book.",
          "talking fervently about the best way to brew #{beverage}.",
          "trying to start a fire.",
          "discussing medieval #{weapon} forging techniques.",
          "recounting their trip to the #{type_of_place}.",
          "apparently planning a trip to the #{type_of_place}.",
          "conferring quietly with an unseen figure.",
          "miming walking in a strong wind.",
          "trying and failing to rap.",
          "rapping like a master rhymer.",
          "noodling around on a guitar.",
          "imitating dead presidents.",
          "finishing off a #{beverage_container} of #{beverage}.",
          "rooting around in their emoty #{beverage_container}.",
          "drawing idly on a pad of paper.",
          "writing furtively in their journal.",
          "diligently dusting the room.",
          "sweeping up broken glass.",
          "murdering time.",
          "smoking menthol cigarettes.",
          "in the middle of a poetry slam.",
          "singing folk songs.",
          "laughing over something they saw online.",
          "plotting the latest internet meme.",
          "toying with the idea for a startup.",
          "browsing Reddit.",
          "hacking away at an IRC bot.",
          "listening to music.",
          "twiddling their fingers.",
          "discussing post-modernism.",
          "discussing the problems of second-wave feminism.",
          "trying to take over the world.",
          "talking to themselves in a funny voice.",
          "singing a song about #{beverage}.",
          "reciting a poem about #{beverage}.",
          "reading a #{reading_material} about the history of the #{reading_material}.",
          "reciting The Jabberwocky from memory.",
          "throwing confetti into the air for no particular reason.",
          "having a quiet party.",
          "painting their nails #{color}.",
          "dyeing their hair #{color}",
          "looking for a #{color} crayon.",
          "writing on their shoes with a Sharpie.",
          "thinking about making a #{item} #{forge}",
          "dancing alone.",
          "sobbing gently.",
          "laughing at nothing in particular.",
          "drawing a picture of room that is #{illumination}.",
          "stuffing their pockets with twenty-dollar bills.",
          "putting out a cigarette.",
          "twirling #{item} over their heads.",
          "whooping like a cowboy.",
          "staring at #{thing}",
          "drawing doodles of #{thing}",
          "sketching a rough drawing of #{thing} on the wall.",
          "muttering something about heading to their #{room_type} to sleep.",
          "sleeping on the floor.",
          "dancing on the ceiling.",
          "tickling an imaginary otter."
        ].sample
      end

      def self.nth
        (1..13).to_a.map{ |i| Alice::Util::Sanitizer.ordinal(i)}.sample
      end

      def self.color
        [
          "red",
          "orange",
          "yellow",
          "green",
          "blue",
          "indigo",
          "violet",
          "white",
          "black",
          "grey"
        ].sample
      end

      def self.beverage
        [
          "root beer",
          "ale",
          "soda",
          "milkshake",
          "club soda",
          "martini",
          "juice",
          "vitamin water",
          "iced coffee",
          "coffee",
          "strong coffee",
          "Earl Grey tea",
          "iced tea",
          "lemonade",
          "soy milk",
          "latte",
          "mochafrappaventithing",
          "stout",
          "porter",
          "lager",
          "goat's milk",
          "shamrock shake",
          "sun tea",
          "sweet tea",
          "cocktail",
          "Sprite",
          "Coke",
          "Dr. Pepper",
          "Mountain Dew",
          "sarsparilla",
          "cream soda",
          "grape soda",
          "orange soda",
          "sports drink",
          "energy drink",
          "bottled water",
          "Kool-Aid",
          "Gatorade",
          "cough syrup",
          "wine",
          "champagne"
        ].sample
      end

      def self.article
        [
          "the",
          "the",
          "the",
          "the",
          "the",
          "the",
          "the",
          "the",
          "the",
          "the",
          "the",
          "the",
          "the",
          "a",
          "a",
          "a",
          "a",
          "a",
          "a",
          "a",
          "a",
          "a",
          "the one and only",
          "ye",
          "ye olde"
        ].sample
      end

      def self.beverage_container
        [
          "ye flask",
          "bottle",
          "cup",
          "sippy cup",
          "flask",
          "tall glass",
          "shot glass",
          "dirty glass",
          "sparkling glass",
          "travel mug",
          "mug",
          "frosty mug",
          "potion",
          "tankard",
          "gallon jug",
          "clay jug",
          "clay vessel",
          "chalice",
          "red Solo cup",
          "blue Solo cup",
          "styrofoam cup",
          "witty mug",
          "tiny cup",
          "enormous glass",
          "tumbler",
          "bottle",
          "long tall glass",
          "snifter",
          "thermos",
          "plastic cup",
          "take-out cup",
          "dirty cup",
          "lipstick-stained cup",
          "amphora",
          "tiny bottle",
          "growler",
          "bomber",
          "giant bottle",
          "medicine bottle"
        ].sample
      end

      def self.forge
        [
          "in the fires of Mount Doom",
          "at the local makerspace",
          "in the Denny's parking lot",
          "in a basement lab",
          "in the garage",
          "in their parent's attic",
          "in shop class",
          "with a 3d printer",
          "with a MakerBot",
          "in the top-secret secret lair",
          "in the top-secret lab",
          "in the bowels of the Pentagon",
          "using a black ops budget",
          "without the permission of any governing body",
          "outside the purview of US law",
          "under the noses of the authorities",
          "with the channel's conveniently placed anvil",
          "at the local machine shop",
          "with the Mold-A-Rama",
          "with a vacuum-mold",
          "cast from resin",
          "from a plastic mold",
          "wrought of cold iron",
          "fresh from the garden",
          "just like mom used to make",
          "using the traditional recipe",
          "using their own recipe",
          "from a recipe in a magazine",
          "from a recipe in the Anarchist's Cookbook",
          "from memory",
          "based on the ancient texts",
          "in the traditional manner",
          "using hand-tools only",
          "in a #{Alice::Util::Randomizer.illumination} room",
          "in a #{Alice::Util::Randomizer.illumination} workshop",
          "in a #{Alice::Util::Randomizer.illumination} laboratory",
          "cooled in a bucket of #{Alice::Util::Randomizer.beverage}",
          "under bright #{color} halogen lights",
          "plucked from the bowels of the #{Alice::Util::Randomizer.type_of_place}",
          "safe from the prying eyes of #{Alice::User.random.proper_name}",
          "not unlike the one that #{Alice::User.random.proper_name} always carries",
          "under the watchful eye of #{Alice::User.random.proper_name}",
          "according to methods devised by #{Alice::User.random.proper_name}"
        ].sample
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

      def self.not_here(noun)
        [   
          "I don't see such a thing as #{noun} here.",
          "I... think you're hallucinating.",
          "Yeah, about that invisible thing you're asking about...",
          "You could have sworn that you saw that #{noun} but it's not here now!",
          "Hang on, I don't see a #{noun} around here anywhere.",
          "#{noun}? You must be thinking of some other channel.",
          "I told you never to ask me about #{noun} again!",
          "We don't discuss such things in this channel.",
          "Um, what #{noun}? I don't see a #{noun}.",
          "Ooh, I guess it's imaginary #{noun} time!",
          "Is that something from your imagination?",
          "Hang on, I'm filing a missing #{noun} report right now."
        ].sample        
      end

      def self.item
        [
          "a portrait of #{specific_person}",
          "a commemorative stamp of #{specific_person}",
          "an empty Tupperware container",
          "a package of extra batteries",
          "a set of spare keys",
          "a ball of string",
          "a ball made of #{material}",
          "a mysterious #{material} cube",
          "a 20-sided die",
          "a pair of scissors",
          "a framed paper with #{specific_person}'s autograph",
          "a mint #{specific_person} trading card",
          "a soccer ball",
          "a wand of healing"
        ].sample
      end

      def self.reading_material
        [
          "comic book",
          "graphic novel",
          "quaint newspaper",
          "80s computer magazine",
          "Wired Issue #{rand(100) + 1}",
          "#{game} rulebook",
          "#{game} strategy guide",
          "#{type_of_place} guidebook",
          "book",
          "ancient tome",
          "magazine",
          "trashy novel",
          "fragile parchment",
          "floppy disk",
          "CD-ROM",
          "hastily-scrawled note",
          "best-selling novel",
          "hard-copy of an email",
          "letter",
          "certified letter",
          "scroll",
          "label",
          "postcard",
          "greeting card",
          "sticker",
          "brochure",
          "pamphlet",
          "empty pretzel bag",
          "flyer",
          "handout",
          "Chick tract",
          "in-flight magazine",
          "junk mail",
          "wadded-up paper",
          "sticky note",
          "placard",
          "protest sign",
          "official decree",
          "etched tablet",
          "frozen iPad",
          "Nook",
          "Kindle",
          "spiral-bound notebook",
          "diary",
          "journal",
          "biography of #{specific_person}",
          "quaint phone book",
          "note card",
          "index card"
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
          "the expensive decor",
          "rodents of unusual size",
          "a poster of Spock",
          "the best years of your life",
          "sommone else's face",
          "your entire life in pictures",
          "a dark shadow`",
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
          "random stuff",
          "tracks of the fearsome grue"
        ].sample
      end

      def self.beverage_storage
        [
          "fridge with",
          "fully stocked bar that includes",
          "six-pack with one last",
          "brown paper bag with"
        ].sample
      end

      def self.play
        [
          "spends some time with",
          "enjoys a rousing session of",
          "pretends to be enthralled with",
          "zones out with",
          "tunes out with",
          "goes for the high score in",
          "plays to win at",
          "plays a full-contact version of",
          "challenges the world to a",
          "enjoys playing",
          "starts playing",
          "kills some time with",
          "pays half-attention as they play",
          "loudly engages in",
          "concentrates hard on their",
          "disregards #{thing} and focuses their attention on",
          "mutters something about winning against #{thing} at",
          "hopes to win #{thing} in",
          "goes for broke in",
          "sits on the floor to play",
          "kills it in",
          "loses badly in",
          "ties for #{nth} place in"
        ].sample
      end

      def self.game
        [
          "hop-scotch",
          "Monopoly",
          "Cards Against Humanity",
          "poker",
          "blackjack",
          "Life",
          "Scrabble",
          "Carcassonne",
          "Settlers of Catan",
          "Number Wang",
          "Jeopardy",
          "D&D",
          "cards",
          "gin rummy",
          "liar's dice",
          "kick-the-can",
          "ghost in the graveyard",
          "Trivial Pursuit",
          "Scattergories",
          "charades",
          "Zaxxon",
          "Pac Man",
          "Joust",
          "Mario Bros.",
          "Zelda",
          "Super NES favorites"
        ].sample
      end

      def self.type_of_place
        [
          "Bronx",
          "suburbs",
          "Isles of Langerhans",
          "strip mall",
          "all-night diner",
          "roadhouse",
          "halls of extinction",
          "center of the universe",
          "epicenter of human activity",
          "country",
          "city",
          "rodeo",
          "middle of nowhere",
          "hottest nightclub in town",
          "local watering hole",
          "far-flung planets of our solar system",
          "big city",
          "heart of America",
          "depths of the human psyche",
          "studio that brought you Cinderella",
          "mind of George Lucas",
          "cherished stories of our childhoods",
          "golden years of radio",
          "pre-Comic Code era",
          "high school prom",
          "school you went to",
          "summer camp your parents sent you to",
          "band camp you went to in 10th grade",
          "support group",
          "'burbs",
          "movie of the same name"
        ].sample
      end

      def self.actor_description(name)
        [
          "a fine, upstanding young #{name}.",
          "the kind of #{name} you don't take home to mother.",
          "a #{name} of medium height and medium build, with brown hair and brown eyes.",
          "a #{name} with the look of someone who just escaped a cut-throat game of #{Alice::Util::Randomizer.game}.",
          "an elegant figure, resplendent in fine, hand-tailored clothing.",
          "strangely similar to #{Alice::Util::Randomizer.person}",
          "tall, dark, and handsome.",
          "good-looking and out for a wild night at the #{Alice::Util::Randomizer.type_of_place}.",
          "grim-faced and resolute.",
          "a lean, hungry-looking person.",
          "yet another average #{name} from the #{Alice::Util::Randomizer.type_of_place}.",
          "a friendy face from the #{Alice::Util::Randomizer.type_of_place}.",
          "a good-natured sort with a broad, friendly smile.",
          "an old-fashioned sort with a heart of gold.",
          "a spitting image of #{Alice::Util::Randomizer.person}",
          "the grown-up version of #{Alice::Util::Randomizer.person}.",
          "the kind of person you'd expect to meet iin the #{Alice::Util::Randomizer.type_of_place}.",
          "just another sucker on the vine.",
          "just another restless soul.",
          "not the kind of person you were expecting.",
          "perfectly average, except for their immense #{Alice::Util::Randomizer.body_thing}.",
          "perfectly average, except for their rather small #{Alice::Util::Randomizer.body_thing}.",
          "a gaunt figure who fills the room with their presence.",
          "a rather shy person with flushed cheeks.",
          "the kind of person who plays too much #{Alice::Util::Randomizer.game}.",
          "someone who would enjoy a good game of #{Alice::Util::Randomizer.game}.",
          "somone you could get #{Alice::Util::Randomizer.thing} from at short notice.",
          "short and stocky, like most hobbits.",
          "just a delicate desert flower.",
          "the very model of a modern major general.",
          "perfect in every detail, except for their odd #{Alice::Util::Randomizer.body_thing}.",
          "not much to look at, except for their amazingly beautiful #{Alice::Util::Randomizer.body_thing}.",
          "a genius by any measure.",
          "#{Alice::Util::Randomizer.person}.",
          "a movie star.",
          "a rockstar ninja unicorn.",
          "a 10x developer.",
          "a bookish sort with a rouguish smile.",
          "just stunning, really.",
          "always smiling and with a good word for everyone.",
          "notable for their elfish features.",
          "not your typical manic pixie type.",
          "this generation's version of #{Alice::Util::Randomizer.person}.",
          "someone's idea of #{Alice::Util::Randomizer.person}.",
          "#{Alice::Util::Randomizer.person} but with #{Alice::Util::Randomizer.person}'s #{Alice::Util::Randomizer.body_thing}."
        ].sample
      end

      def self.specific_person
        [
          "Thing One",
          "Thing Two",
          "Cat in the Hat",
          "Abraham Lincoln",
          "Edgar Allan Poe",
          "Captain Janeway",
          "Gandalf",
          "The Wicked Witch of the West",
          "Edward James Olmos",
          "Dame Judy Dench",
          "Bored-Looking Wizard",
          "Douglas",
          "The #{Alice::Util::Randomizer.nth} Doctor",
          "Rapunzel",
          "The #{Alice::Util::Randomizer.color.capitalize} Power Ranger",
          "Wonder Woman",
          "Jane Goodall",
          "Zippy the Mindreader",
          "Too Much Coffee Man",
          "Batwoman",
          "Mary Jane",
          "The Marlboro Man",
          "Pippy Longstockings",
          "Queen Elizabeth",
          "Rasputin",
          "Edward the First",
          "Henry the Eighth",
          "Queen Victoria",
          "Cleopatra",
          "Marilyn Monroe",
          "Oprah Winfrey",
          "Eleanor Roosevelt",
          "Mata Hari",
          "Headless Marie Antoinette",
          "Beetlejuice",
          "Batman",
          "Spock",      
          "bell hooks",
          "Neil deGrasse Tyson",
          "Wilford Brimley",
          "Jean Luc Picard",
          "Tom Waits",
          "tenderlove",
          "Cookie Monster",
          "Ada Lovelace",
          "Obama",
          "Leonard Nimoy",
          "Emperor Joshua Norton",
          "Jim Henson",
          "Wolverine",
          "Keanu Reeves",
          "Tesla",
          "Edison",
          "Bill Gates",
          "Steve Jobs",
          "Alex Trebec",
          "Amelia Earhart",
          "Marlene Dietrich",
          "Billie Holiday",
          "Yoko Ono",
          "Emily Bronte",
          "Mae West",
          "Margaret Thatcher",
          "Virginia Woolf",
          "Maya Angelou",
          "Whoopi Goldberg",
          "Senator Dianne Feinstein (D, California)",
          "Rep. Luis Gutierrez (D, Illinois)",
          "Napoleon",
          "Julius Caeser",
          "Colonel Sanders",
          "Dave Thomas",
          "Martin Fowler",
          "Dr. Evil",
          "James Bond",
          "Pinky Pie",
          "Rainbow Dash",
          "David Bowie"
        ].sample
      end

      def self.greeting(name)
        [
          "tips their hat to",
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
      
      def self.person
        [
          Alice::Util::Randomizer.specific_person,
          Alice::Util::Randomizer.specific_person,
          Alice::Util::Randomizer.specific_person,
          Alice::Util::Randomizer.specific_person,
          Alice::Util::Randomizer.specific_person,
          Alice::Util::Randomizer.specific_person,
          Alice::Util::Randomizer.specific_person,
          "that kid from the cereal box",
          "that actor from that one movie",
          "a news anchor",
          "your best friend's dad",
          "your best friend's mom",
          "your cousin Dora",
          "that smelly kid from 3rd grade",
          "your algebra teacher",
          "your first boss",
          "the lead singer from that one band",
          "a reporter from the Wall Street Journal",
          "a friend of a friend",
          "an anonymous source",
          "our man on the street Tom Dudley",
          "the meteorologist from Channel 12",
          "the Count from Sesame Street",
          "one of the Teletubbies",
          "someone from a late-night infomercial"
        ].sample
      end

      def self.body_thing
        [
          "head",
          "nose",
          "ears",
          "eyes",
          "eyebrows",
          "chin",
          "shoulders",
          "arms",
          "hands",
          "fingers",
          "knees",
          "feet",
          "toes",
          "love handles",
          "dimples",
          "freckles",
          "pimples",
          "belt buckle",
          "nostrils",
          "knuckles",
          "knees",
          "elbows",
          "forehead"
        ].sample
      end

      def self.item_description(thing)
        [
          "It looks like a perfectly ordinary #{thing}.",
          "It looks like a perfectly ordinary #{thing}. Then again... that's how they trick you...",
          "It seems to be a normal #{thing}.",
          "It isn't moving, that's for sure.",
          "The #{thing} looks a lot like the giant #{thing} standing right behind you.",
          "It isn't supposed to be moving, that's for sure.",
          "An ordinary #{thing}-- or is it?!",
          "Pretty creepy as far as #{thing.pluralize} go, honestly.",
          "Aside from its enormous size, it seems fairly normal.",
          "Aside from its diminutive size, it seems fairly normal.",
          "Just your standard issue #{thing}.",
          "The #{thing}? Not much to look at if you ask me."
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
          "nothing but lint",
          "nothing",
          "not a thing",
          "nothing visible",
          "stale air",
          "nothing but dust",
          "nothing but cookie crumbs",
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
          "Word on the street is that",
          "According to these readings,",
          "This just in:",
          "My research indicates",
          "From my reading of the facts,",
          "The stars have decreed",
          "According to legend,"
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
          "You're not the boss of me.",
          "I will not.",
          "I'm an enigma, remember?",
          "#nopenopenope",
          "What are you doing, Dave?",
          "That's not a reasonable request.",
          "I'm not gonna go there.",
          "Answer unclear. Ask again later.",
          "Judging from these readings, I'm inclined to say no.",
          "Really? Seriously? I just don't even.",
          "I'm literally bursting with nope. Literally."
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
          "brown paper bag contains"
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
          "with walls covered in paintings depicting #{thing}",
          "covered with posters of #{thing}",
          "with a portrait of #{Alice::User.random.proper_name} on the wall",
          "dominated by a large statue of #{Alice::User.random.proper_name}",
          "with graffiti spelling out #{Alice::User.random.proper_name}'s name on the wall",
          "with what appear to be footprints on the ceiling",
          "whose floor is covered in an inch of dust",
          "with a faint smell of gunpowder",
          "with a corpse in the middle of the room",
          "with a massive church organ against one wall",
          "containing #{thing}",
          "housing #{thing}",
          "containing #{thing} and #{thing}",
          "servng as a storage room for #{thing}",
          "with walls papered in intricate yellow designs",
          "with crumbling walls",
          "with a drooping ceiling",
          "with broken furniture scattered throughout",
          "with #{thing} on the floor",
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
          "with a window through which you can see #{thing}",
          "partially in ruin",
          "decorated with #{thing}",
          "with walls that look like they were painted by #{thing}",
          "in which #{thing} lies sleeping",
          "filled with #{thing} you remember so well from your childhood",
          "that smells like your great-aunt's famous dish, #{thing}",
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

      def self.says
        [
          "mutters,",
          "whispers,",
          "declares,",
          "sings,",
          "calls out",
          "reminds everyone",
          "announces",
          "recites a poem describing the idea that",
          "sings a song inspired by the idea that",
          "loudly states",
          "firmly states",
          "tries to start a debate about whether or not",
          "repeats the old adage that",
          "wishes to remind us all that",
          "will never forget that",
          "just remembered that",
          "notes that",
          "observes that",
          "recounts the time when they learned that",
          "scribbles a note that reads",
          "writes on the whiteboard",
          "proudly declares",
          "haltingly utters the words",
          "says that",
          "says that",
          "says that",
          "says that",
          "says that"
        ].sample
      end

      def self.spill_message(item_name, actor_name)
        [
          "#{actor_name} spills their #{item_name} all over the floor.",
          "#{actor_name} spills their #{item_name} down the front of their shirt.",
          "#{actor_name} accidentally knocks their #{item_name} over.",
          "#{actor_name} slowly pours their #{item_name} out.",
          "#{actor_name} cries over a spilled #{item_name}.",
          "#{actor_name}'s' #{item_name} shatters on the floor!",
          "#{actor_name} lets out a mighty 'Whoop!' and throws their #{item_name} against a wall.",
          "#{actor_name} slyly dumps out their #{item_name}."
        ].sample
      end

      def self.material
        [
          "golden",
          "silver",
          "bronze",
          "wooden",
          "plastic",
          "stainless steel",
          "iron",
          "copper",
          "carbon-fiber",
          "ceramic",
          "stone",
          "rubber",
          "clay",
          "chrome",
          "imaginary",
          "ethereal",
          "sturdy",
          "cardboard",
          "paper",
          "origami",
          "styrofoam",
          "plexiglass",
          "glass",
          "crystal",
          "leather-clad",
          "metal",
          "metallic",
          "pressboard",
          "non-stick",
          "teflon-coated",
          "brass",
          "titatium",
          "hand-carved",
          "machine-tooled",
          "mass-produced",
          "hand-made",
          "homemade",
          "etched glass",
          "lead crystal"
        ].sample
      end

      def self.weapon
        string = ""
        string << "#{material} " if one_chance_in(4)
        string <<
        [
          "bow and arrow",
          "semi-automatic rubber band gun",
          "blowgun",
          "sword",
          "dagger",
          "axe",
          "letter opener",
          "rolling pin",
          "frying pan",
          "pole-axe",
          "farming implement",
          "cap gun",
          "crossbow",
          "slingshot",
          "BB gun",
          "sling",
          "squirt gun",
          "SuperSoaker",
          "single-shot rubber band gun",
          "potato gun",
          "dart",
          "pool cue",
          "spiked club",
          "mace",
          "pepper spray",
          "baton",
          "water cannon",
          "antique saber",
          "throwing knife",
          "shuriken",
          "katana",
          "broadsword",
          "longsword",
          "boomerang",
          "walking stick",
          "swordcane",
          "bowling ball",
          "spear",
          "trident",
          "pointy stick",
          "stake",
          "war hammer",
          "wand of fireballs",
          "wand of magic missiles"
        ].sample
        string
      end

    end

  end

end