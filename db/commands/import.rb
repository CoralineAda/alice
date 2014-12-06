require_relative '../../alice'
Command.create(
	name: 'steal',
	verbs: ["steal"],
	stop_words: ["stuff"],
	indicators: [],
	handler_class: 'Handlers::Item',
	handler_method: 'steal',
	response_kind: 'message',
)
Command.create(
	name: 'seen',
	verbs: ["seen"],
	stop_words: [],
	indicators: [],
	handler_class: 'Handlers::Emotes',
	handler_method: 'seen',
	response_kind: 'message',
)
Command.create(
	name: 'summon',
	verbs: ["summon"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Actor',
	handler_method: 'summon',
	response_kind: 'message',
)
Command.create(
	name: 'talk',
	verbs: ["talk"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Actor',
	handler_method: 'talk',
	response_kind: 'message',
)
Command.create(
	name: 'brew',
	verbs: ["brew", "distill", "concoct", "mix"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Beverage',
	handler_method: 'brew',
	response_kind: 'message',
)
Command.create(
	name: 'drink',
	verbs: ["drink", "quaff", "consume", "chug", "sip"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Beverage',
	handler_method: 'drink',
	response_kind: 'message',
)
Command.create(
	name: 'bio',
	verbs: ["bio"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Bio',
	handler_method: 'process',
	response_kind: 'message',
)
Command.create(
	name: 'look',
	verbs: ["look"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Dungeon',
	handler_method: 'look',
	response_kind: 'message',
)
Command.create(
	name: 'move',
	verbs: ["east", "west", "north", "south"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Dungeon',
	handler_method: 'move',
	response_kind: 'message',
)
Command.create(
	name: 'map',
	verbs: ["map"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Dungeon',
	handler_method: 'map',
	response_kind: 'message',
)
Command.create(
	name: 'xyzzy',
	verbs: ["xyzzy"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Dungeon',
	handler_method: 'xyzzy',
	response_kind: 'message',
)
Command.create(
	name: 'attack',
	verbs: ["attack", "kill"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Dungeon',
	handler_method: 'attack',
	response_kind: 'message',
)
Command.create(
	name: 'cast',
	verbs: ["cast"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Emotes',
	handler_method: 'cast',
	response_kind: 'message',
)
Command.create(
	name: 'help',
	verbs: ["help"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Emotes',
	handler_method: 'help',
	response_kind: 'message',
)
Command.create(
	name: 'stats',
	verbs: ["stats", "stat"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Emotes',
	handler_method: 'stats',
	response_kind: 'message',
)
Command.create(
	name: 'source',
	verbs: ["source", "github", "repo"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Emotes',
	handler_method: 'source',
	response_kind: 'message',
)
Command.create(
	name: 'bug',
	verbs: ["bug"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Emotes',
	handler_method: 'bug',
	response_kind: 'message',
)
Command.create(
	name: 'one_ring',
	verbs: [],
	stop_words: [],
	indicators: ["one ring"],
	handler_class: 'Handlers::Emotes',
	handler_method: 'one_ring',
	response_kind: 'message',
)
Command.create(
	name: 'set_fact',
	verbs: ["fact", "remember"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Factoid',
	handler_method: 'set',
	response_kind: 'message',
)
Command.create(
	name: 'get_fact',
	verbs: [],
	stop_words: [],
	indicators: ["know", "fact", "factoid", "tell"],
	handler_class: 'Handlers::Factoid',
	handler_method: 'get',
	response_kind: 'message',
)
Command.create(
	name: 'number_wang',
	verbs: ["13"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Game',
	handler_method: 'number_wang',
	response_kind: 'message',
)
Command.create(
	name: 'give_points',
	verbs: ["+"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Points',
	handler_method: 'give',
	response_kind: 'message',
)
Command.create(
	name: 'greet',
	verbs: ["hi", "hello", "hey", "heya", "morning", "afternoon", "evening", "night"],
	stop_words: [],
	indicators: [],
	handler_class: 'Handlers::Greeting',
	handler_method: 'greet_sender',
	response_kind: 'emote',
)
Command.create(
	name: 'inventory',
	verbs: ["inventory"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Inventory',
	handler_method: 'inventory',
	response_kind: 'message',
)
Command.create(
	name: 'destroy',
	verbs: ["destroy", "obliterate", "consume", "break"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Item',
	handler_method: 'destroy',
	response_kind: 'message',
)
Command.create(
	name: 'drop',
	verbs: ["drop", "release", "let go"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Item',
	handler_method: 'drop',
	response_kind: 'message',
)
Command.create(
	name: 'hide',
	verbs: ["hide"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Item',
	handler_method: 'hide',
	response_kind: 'message',
)
Command.create(
	name: 'take',
	verbs: ["take", "pick up", "grab"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Item',
	handler_method: 'take',
	response_kind: 'message',
)
Command.create(
	name: 'forge',
	verbs: ["create", "forge", "make", "assemble"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Item',
	handler_method: 'forge',
	response_kind: 'message',
)
Command.create(
	name: 'give',
	verbs: ["give", "hand", "transfer"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Item',
	handler_method: 'give',
	response_kind: 'message',
)
Command.create(
	name: 'play',
	verbs: ["play"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Item',
	handler_method: 'play',
	response_kind: 'message',
)
Command.create(
	name: 'read',
	verbs: ["read", "scan", "peruse"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Item',
	handler_method: 'read',
	response_kind: 'message',
)
Command.create(
	name: 'catalog',
	verbs: ["catalog", "machines"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Machine',
	handler_method: 'catalog',
	response_kind: 'message',
)
Command.create(
	name: 'install',
	verbs: ["install"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Machine',
	handler_method: 'install',
	response_kind: 'message',
)
Command.create(
	name: 'use',
	verbs: ["use", "operate"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Machine',
	handler_method: 'use',
	response_kind: 'message',
)
Command.create(
	name: 'oh_set',
	verbs: ["OH", "OH:"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::OH',
	handler_method: 'set',
	response_kind: 'message',
)
Command.create(
	name: 'get_oh',
	verbs: [],
	stop_words: [],
	indicators: ["hearing", "said", "overheard", "saying"],
	handler_class: 'Handlers::OH',
	handler_method: 'get',
	response_kind: 'message',
)
Command.create(
	name: 'lottery',
	verbs: ["lottery"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Points',
	handler_method: 'lottery',
	response_kind: 'message',
)
Command.create(
	name: 'check_points',
	verbs: ["points"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Points',
	handler_method: 'check',
	response_kind: 'message',
)
Command.create(
	name: 'scores',
	verbs: ["scores", "leaderboard"],
	stop_words: [],
	indicators: [],
	handler_class: 'Handlers::Points',
	handler_method: 'leaderboard',
	response_kind: 'message',
)
Command.create(
	name: 'set_twitter',
	verbs: ["twitter"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Twitter',
	handler_method: 'set',
	response_kind: 'message',
)
Command.create(
	name: 'get_twitter',
	verbs: [],
	stop_words: [],
	indicators: ["twitter", "handle"],
	handler_class: 'Handlers::Twitter',
	handler_method: 'get',
	response_kind: 'message',
)
Command.create(
	name: 'wand',
	verbs: ["wield", "wave"],
	stop_words: ["alice"],
	indicators: [],
	handler_class: 'Handlers::Wand',
	handler_method: 'use',
	response_kind: 'message',
)
Command.create(
	name: 'well_actually',
	verbs: [],
	stop_words: [],
	indicators: ["well actually", "well, actually"],
	handler_class: 'Handlers::Emotes',
	handler_method: 'well_actually',
	response_kind: 'message',
)
Command.create(
	name: 'pronouns',
	verbs: ["pronouns"],
	stop_words: [""],
	indicators: [],
	handler_class: 'Handlers::Pronouns',
	handler_method: 'process',
	response_kind: 'message',
)
Command.create(
	name: 'dance',
	verbs: ["dance"],
	stop_words: [""],
	indicators: [],
	handler_class: 'Handlers::Emotes',
	handler_method: 'dance',
	response_kind: 'message',
)
Command.create(
	name: 'commands',
	verbs: ["commands"],
	stop_words: [],
	indicators: [],
	handler_class: 'Handlers::Emotes',
	handler_method: 'commands',
	response_kind: 'message',
)
Command.create(
	name: 'youre_welcome',
	verbs: [],
	stop_words: [],
	indicators: ["thank", "thanks"],
	handler_class: 'Handlers::Emotes',
	handler_method: 'youre_welcome',
	response_kind: 'message',
)
Command.create(
	name: 'loose_greeting',
	verbs: [],
	stop_words: [],
	indicators: ["hi", "hello", "hey", "afternoon", "evening", "greetings", "hola", "hai"],
	handler_class: 'Handlers::Greeting',
	handler_method: 'greet_sender',
	response_kind: 'emote',
)
Command.create(
	name: 'sentinel',
	verbs: [""],
	stop_words: [""],
	indicators: [],
	handler_class: 'Handlers::Item',
	handler_method: 'steal',
	response_kind: 'message',
)
Command.create(
	name: 'eat',
	verbs: ["eat", "consume", "munch", "swallow", "drink"],
	stop_words: [],
	indicators: [],
	handler_class: 'Item',
	handler_method: 'eat',
	response_kind: 'message',
)
puts 'Command import complete.'
