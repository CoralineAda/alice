module Alice

  module Util

    class Randomizer

      def self.one_chance_in(number)
        rand(number) == 0
      end

      def self.random_user
        user = User.active_and_online.sample
        user ||= User.all.sample
        user.current_nick
      end

      def self.talking_about(topic)
        message = [
          "I think we're talking about #{topic}",
          "Well, the grownups were discussing #{topic}",
          "I'm not sure, but I think we're discussing #{topic}",
          "We're discussing #{topic}",
          "I was just thinking about #{topic}",
          "I think we were on the subject of #{topic}",
          "How about them #{topic}s",
          "#{topic} is the topic d'jour",
          "It's all about #{topic}, amirite?",
          "Today it's all about #{topic}",
          "Our reading today is from the Book of #{topic.titleize}",
          "Ah yes, #{topic}",
          "Let's get back to talking about #{topic}",
          "I'd like to look at #{topic} some more"
        ].sample
      end

      def self.thanks_response(who)
        message = [
          "You are most welcome, #{who}!",
          "No problem.",
          "Sure thing.",
          "Anytime.",
          "Don't mention it.",
          "Don't mention it. No really, please don't mention it.",
          "It was the least I could do.",
          "You're totally worth it.",
          "You're welcome!"
        ].sample
      end

      def self.got_nothing
        message = [
          "Let me Google that for you. Sigh.",
          "Sorry, I've got nothing.",
          "Really? That again?",
          "Let's change the subject, OK?",
          "Excuse me, I've got something in my eye.",
          "I don't want to talk about that, really.",
          "Nope nope nope.",
          "You seem a little fixated.",
          "Do you kiss your mother with that mouth?",
          "I'd rather not relive my experiences with that.",
          "If it's all the same to you, I'd rather not talk about it."
        ].sample
      end

      def self.brew_observation(what, who, args={})
        message = [
          "looks on in wonder as #{who} brews a perfect #{what}.",
          "watches #{who} whip up #{what}.",
          "watches #{who} brew a nice #{what}.",
          "watches #{who} brew a #{what}.",
          "watches as #{who} makes a #{what}.",
          "watches #{who} brew a decent #{what}.",
          "notices #{who} brewing a #{what}.",
          "applauds as #{who} makes a #{what}.",
          "nods approvingly as #{who} brews a #{what}.",
          "admires #{who}'s ability to whip up a mean #{what}.",
          "smiles and says, 'That's a fine #{what}!'",
          "admires #{who}'s brewing prowess."
        ].sample
        message << " It looks rather potent." if args[:is_alcohol]
        message
      end

      def self.summon_failure(who, whom)
        [
          "#{who} looks crestfallen when #{whom} fails to appear.",
          "#{who} gesticulates wildly, to no effect.",
          "#{who} should not summon that which cannot be banished!"
        ].sample
      end

      def self.disarm_message(who, what)
        [
          "#{who} is quite disarming!",
          "#{who} deftly disarms the #{what}.",
          "#{what} proves to be no match for the wily #{name}."
        ].sample
      end

      def self.exclamation
        [
          "Dude...",
          "Whoa!",
          "OMG!",
          "OMFG!",
          "Damn!",
          "Hold on.",
          "Wha?",
          "What?",
          "No way.",
          "Hmm.",
          "Sorry, but",
          "That was distracting."
        ].sample
      end

      def self.keys
        [
          "a giant skeleton key",
          "house key",
          "lockpick",
          "bobby pin",
          "keyring",
          "rabbit's foot key chain",
          "#{specific_person}'s car keys",
          "#{material} skeleton key",
          "#{material} skeleton key",
          "#{material} skeleton key",
          "#{material} skeleton key",
          "#{material} skeleton key"
        ].sample
      end

      def self.view_from_afar
        [
          "It looks safe enough.",
          "Pretty sure there's no imminent danger there.",
          "Probably fine. Probably.",
          "There might be something shiny in there!",
          "Nothing to see, but there's quite a smell coming from that direction.",
          "Perfectly ordinary room.",
          "You see a bloodthirsty monster. Just kidding!",
          "You think you saw #{person} leaving the room, but you're not sure.",
          "Listen! Do you smell something?",
          "It's... It's... another room!",
          "Why not just enter the room and see up close?",
          "A real hero woud leap before they looked.",
          "You're just gonna have to go that way and see for yourself.",
          "Wait, weren't you just in that room?",
          "Looks remarkably like another room you've seen.",
          "There is a trail of breadcrumbs leading that way.",
          "There is a silver thread leading off in that direction.",
          "You spy an evil, sneaky room, ready to pounce on unsuspecting adventuring parties.",
          "Looks normal enough, so it's probably trapped or something.",
          "There are muddy footprints leading that way.",
          "Someone was recently in that room, you can just tell.",
          "Though you see no piano in that direction, you hear the unmistakable sound of someone smashing the keyboard of one.",
          "Rest assured, it's safe that way...",
          "You don't want to go that way, trust me.",
          "I don't know, looks pretty sketchy to me.",
          "It's a room alright.",
          "There's bound to be adventure in that direction."
        ].sample
      end

      def self.give_message(giver, receiver, thing)
        [
          "#{giver} hands #{thing} to #{receiver}.",
          "#{giver} passes #{thing} to #{receiver}.",
          "#{receiver} is now the proud owner of #{thing}, only slightly used.",
          "#{receiver} notes that #{thing} has a lot of carbon scoring, and must have seen some action.",
          "#{giver} tosses #{thing} to #{receiver}, who catches it deftly.",
          "#{giver} throws #{thing} to #{receiver}, who almost drops it!",
          "#{giver}, with a tear in their eye, slowly hands #{thing} over to #{receiver}",
          "Who is the new owner of #{thing}? #{receiver} is!",
          "#{receiver} quickly stuffs #{thing} into their bag, before #{giver} changes their mind.",
          "#{giver} signs over #{thing} to #{receiver}.",
          "#{giver} gave #{thing} to #{receiver}? Well that just happened."
        ].sample
      end

      def self.dance(dancer, partner)
        [
          "#{dancer} waltzes around with #{partner}.",
          "#{dancer} and #{partner} cut a rug!",
          "#{dancer} and #{partner} do the pogo all around the room.",
          "#{dancer} and #{partner} appear to be walking like Egyptians.",
          "#{dancer} has two left feet. No, I mean literally two left feet.",
          "Watching #{dancer} and #{partner} like this brings a tear to the eye"
        ].sample
      end

      def self.destroy_message(what)
        [
          "drops the #{what} into the fires of Mount Doom! That should do it.",
          "destroyed the #{what}. See, that's why we can't have nice things.",
          "smashed the #{what} into pieces. Someone should clean that up.",
          "thinks you will regret not having the #{what} anymore. Mark my words.",
          "melts the #{what} in the microwave.",
          "sends the #{what} to the store for cigarettes, and it's never seen again.",
          "watches in disbelief as #{person} devours the #{what}!",
          "smiles as #{specific_person} carts the #{what} off to its doom.",
          "will never see that #{what} again.",
          "throws a going-away party for the #{what}.",
          "sobs as the #{what} crumbles to dust.",
          "gives the #{what} an unforgettable send-off.",
          "melts the #{what} down into a smelly puddle of goo.",
          "shivers, the last words of the #{what} still ringing in their ears.",
          "marks the passing of yet another #{what}.",
          "smiles as the #{what} recedes into the sunset.",
          "exercises the nuclear option and vaporizes the #{what}.",
          "thinks you will miss that #{what} one day.",
          "knows that you loved the #{what}, and that's why you had to let it go."
        ].sample
      end

      def self.spell_effect(caster, spell)
        [
          "#{caster} waves a wand but nothing happens.",
          "#{caster} attacks the darkness!",
          "#{caster} tries and fails to cast #{spell}.",
          "#{caster} casts an impressive variant of #{spell}.",
          "Holding their wand aloft, #{caster} casts #{spell}!",
          "#{caster} did not learn their lesson from last time, apparently.",
          "#{spell} is not available at #{caster}'s current level.",
          "The #{spell} fizzles.",
          "#{caster} temporarily turns into #{specific_person}.",
          "Great, now everyone in the channel looks like #{person}.",
          "There is suddenly an overwhelming smell of #{thing}.",
          "A #{thing} appears out of nowhere and runs #{Place.current.exits.sample}!",
          "The illusion of a #{thing} appears, to all appearances #{action}",
          "The face of #{specific_person} flickers in mid-air, frowns, and then vanishes.",
          "The room is filled with a dense #{color} fog.",
          "When #{caster} waves their hands, a #{thing} flies across the room and smashes!",
          "With a word from #{caster}, the ghost of a #{person} materializes and asks to play #{game} with everyone.",
          "A portal to the #{type_of_place} flickers into existence!",
          "#{caster} turns into #{actor_description(specific_person)}.",
          "#{caster} takes on the appearance of #{specific_person}.",
          "#{random_user} starts speaking in the voice of #{specific_person}.",
          "#{random_user}'s #{body_thing} turns #{color}!",
          "#{caster} summons a fearsome #{thing}!",
          "#{caster} tries to summon a mighty #{thing}, but manages only #{empty_pockets}.",
          "#{effect_message('spell', random_user)}",
          "a #{room_type} appears somewhere deep in the dungeon."
        ].sample
      end

      def self.cant_touch_this(verb, noun)
        [
          "You can't go around #{verb}ing #{noun}s all willy-nilly.",
          "Issues much?",
          "The #{noun} is NOT amused.",
          "While that may be technically possible, it is ill advised.",
          "I can't let you do that.",
          "Um, let's say no?",
          "That #{noun} will hurt you if you're not careful.",
          "Let's do something else instead.",
          "Shouldn't you be hunting the grue instead of messing around with #{noun.pluralize}?",
          "It's been established that if you #{verb} #{noun.pluralize}, you are likely to attract a grue.",
          "I'm not sure that you should really #{verb} a #{noun}.",
          "Are you saying that the #{noun} is a clown here for your amusement?",
          "Fine, if I let you #{verb} the #{noun} can we get on with our lives?",
          "She who #{verb.pluralize} the #{noun} must also #{verb} herself.",
          "It's a crazy world where people go around #{verb}ing all the #{noun.pluralize} they see.",
          "Next thing you know you'll be asking to #{verb} the grue!",
          "I didn't peg you for a '#{noun}' person.",
          "Do you always go around #{verb}ing things?"
        ].sample
      end

      def self.negative_request_response(name)
        [
          "calls BS on #{name}.",
          "stares blankly at #{name}",
          "shakes her head at #{name}",
          "refuses to listen to #{name} anymore.",
          "snaps her eyes shut and shakes her head."
        ].sample
      end

      def self.positive_request_response(name)
        [
          "listens carefully and nods to herself.",
          "googles to verify that.",
          "makes a mental note.",
          "grins and winks at #{name}.",
          "nods sagely.",
          "nods at #{name}.",
          "stares fixedly at #{name}.",
          "commits that to memory.",
          "will remember that, #{name}.",
          "thinks that should go on the Twitters.",
          "suspects that soneone will tweet about that.",
          "remembers something about that from earlier."
        ].sample
      end

      def self.action
        [
          "lurking nearby.",
          "hiding behind the door.",
          "whispering softly.",
          "hissing like a snake.",
          "standing around listlessly.",
          "playing a quiet game of Chutes and Ladders.",
          "pretending to read a book.",
          "talking fervently about the best way to brew a #{beverage}.",
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
          "finishing off a #{beverage_container} of a #{beverage}.",
          "rooting around in their empty #{beverage_container}.",
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
          "singing a song about a #{beverage}.",
          "reciting a poem about a #{beverage}.",
          "reading a #{reading_material} about the history of the #{reading_material}.",
          "reciting The Jabberwocky from memory.",
          "throwing confetti into the air for no particular reason.",
          "having a quiet party.",
          "painting their nails #{color}.",
          "dyeing their hair #{color}",
          "looking for a #{color} crayon.",
          "writing on their shoes with a Sharpie.",
          "thinking about making #{item} #{forge}.",
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
          "safe from the prying eyes of #{User.random.proper_name}",
          "not unlike the one that #{User.random.proper_name} always carries",
          "under the watchful eye of #{User.random.proper_name}",
          "according to methods devised by #{User.random.proper_name}"
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
          "someone else's face",
          "your entire life in pictures",
          "a dark shadow",
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
          "concentrates hard on",
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
          "another Super NES favorite"
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
          "a bookish sort with a roguish smile.",
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
          "Dwarf from Twin Peaks",
          "Thing One",
          "Thing Two",
          "Cat in the Hat",
          "Abraham Lincoln",
          "Edgar Allan Poe",
          "Captain Janeway",
          "Gandalf",
          "Wicked Witch of the West",
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
          "Marlboro Man",
          "Pippi Longstocking",
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
          "Dread Pirate Roberts",
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
          "Julius Caesar",
          "Colonel Sanders",
          "Dave Thomas",
          "Martin Fowler",
          "Dr. Evil",
          "James Bond",
          "Pinkie Pie",
          "Rainbow Dash",
          "David Bowie"
        ].sample
      end

      def self.greeting(name)
        [
          "tips her hat to",
          "gives a tip of the old chapeau to",
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

      def self.drink_description(thing)
        [
          "A delicious new beverage from the makers of #{beverage.titleize}™.",
          "Drinkable, but perhaps a little flat.",
          "It seems like ordinary #{thing}.",
          "There's something floating in it, but it's probably fine.",
          "You shouldn't examine your drinks so closely.",
          "It's giving off an otherworldly glow but otherwise seems normal.",
          "Is it supposed to have bubbles like that?",
          "Pretty tame as far as #{thing.pluralize} go.",
          "I think that #{thing} is an acquired taste.",
          "It looks delicious!",
          "You're getting thirsty just looking at it.",
          "The #{thing}? Well, it's better than #{beverage}."
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
          "An ordinary #{thing}— or is it?!",
          "Pretty creepy as far as #{thing.pluralize} go, honestly.",
          "Aside from its enormous size, it seems fairly normal.",
          "Aside from its diminutive size, it seems fairly normal.",
          "Just your standard issue #{thing}.",
          "The #{thing}? Not much to look at if you ask me.",
          "Cool, it's got skulls on it!",
          "Looks like someone went all out on this #{thing}.",
          "This is one tricked-out #{thing}.",
          "You've never seen a #{thing} quite like this one.",
          "Ooh, it's numbered: #{rand(20) + 1} of 100!",
          "A #{thing} like this would cost a pretty penny from SkyMall.",
          "Looks like the genuine article to me.",
          "Sleek, seamless, and #{material}.",
          "Hmm, mass-produced by the look of it, but not a bad #{thing}.",
          "A Hello Kitty version of #{thing} would be cooler, but it's pretty nice all the same."
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
          "Some say that ",
          "I heard recently that ",
          "Someone said that ",
          "A wise person once said ",
          "It's been said that "
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
          "#{actor_name} drops the #{item_name}.",
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
          "#{actor_name} sips the #{item_name}.",
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
          "That makes #{actor_name} feel a little dizzy.",
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
          "#{actor_name} feels a sudden urge to dance.",
          "#{actor_name} can't seem to stop hiccuping.",
          "#{actor_name} is giggling uncontrollably."
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
          "Now #{actor_name}'s #{item_container} holds the #{item_name}."
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
          "with a boarded-up window on the far wall",
          "with scratches along the floor",
          "with claw marks on the wall",
          "with bare shelves lining the walls",
          "with walls covered in paintings depicting #{thing}",
          "covered with posters of #{thing}",
          "with a portrait of #{User.random.proper_name} on the wall",
          "dominated by a large statue of #{User.random.proper_name}",
          "with graffiti spelling out #{User.random.proper_name}'s name on the wall",
          "with what appear to be footprints on the ceiling",
          "whose floor is covered in an inch of dust",
          "with a faint smell of gunpowder",
          "with a corpse in the middle of the room",
          "with a massive church organ against one wall",
          "containing #{thing}",
          "housing #{thing}",
          "containing #{thing} and #{thing}",
          "serving as a storage room for #{thing}",
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
          "pit",
          "laboratory",
          "showroom",
          "ballroom",
          "music studio",
          "basement",
          "attic room",
          "utility closet",
          "break room",
          "salon",
          "vault",
          "bedroom",
          "child's bedroom",
          "play room",
          "control room",
          "observation deck",
          "captain's chambers",
          "meeting room",
          "conference room",
          "kitchenette",
          "observatory",
          "rumpus room",
          "exhibition hall",
          "locker room",
          "darkroom",
          "pharmacy",
          "home office",
          "boiler room",
          "server room"
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
          "Mr. Pointy",
          "stake",
          "war hammer",
          "wand of fireballs",
          "wand of magic missiles"
        ].sample
        string
      end

      def self.points_dont_matter
        [
          "the comments on Hacker News",
          "Microsoft's latest mobile offering",
          "Fleetwood Mac's box set",
          "a dudebro's opinion"
        ].sample
      end

    end

  end

end
