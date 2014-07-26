require './alice'

namespace :commands do

  desc "Create default commands"
  task :create_defaults do

    # Actor handler

    Command.create(
      name: 'summon',
      verbs: ["summon", "invite", "call"],
      stop_words: [],
      handler_class: 'Handlers::Actor',
      handler_method: :summon,
      response_kind: :message
     )

    Command.create(
      name: 'talk',
      verbs: ["talk", "chat", "ask"],
      stop_words: [],
      handler_class: 'Handlers::Actor',
      handler_method: :talk,
      response_kind: :message
     )

    Command.create(
      name: 'brew',
      verbs: ["brew", "distill", "pour"],
      stop_words: [],
      handler_class: 'Handlers::Beverage',
      handler_method: :brew,
      response_kind: :emote
    )
    Command.create(
      name: 'beverage',
      verbs: ["pour","drink","quaff","sip","swallow","gulp","down","chug"],
      stop_words: [],
      handler_class: 'Handlers::Beverage',
      handler_method: :drink,
      response_kind: :emote
    )
    Command.create(
      name: 'twitter',
      indicators: ["twitter", "handle", "nick", "who", "what", "handl"],
      stop_words: [],
      handler_class: 'Handlers::Twitter',
      response_kind: :message
    )
    Command.create(
      name: 'greeting',
      indicators: ["hi", "hello", "hey", "heya", "o/", "\\o", "greetings", "greets", "greet", "morning", "afternoon", "evening", "mornin", "morgen", "dias", "tagen", "evenin", "love", "hate", "hug"],
      stop_words: [],
      handler_class: 'Handlers::Greeting',
      response_kind: :message
    )
    Command.create(
      name: 'inventory',
      indicators: ["inventory", "pockets", "purse", "satchel", "backpack", "back pack", "bag", "holding", "stuff", "carry", "inventori", "pocket", "purs", "hold", "carri", "what"],
      stop_words: [],
      handler_class: 'Handlers::Inventory',
      response_kind: :message
    )
    Command.create(
      name: 'bio',
      indicators: ["tell", "about", "something", "who", "is", "someth", "low-down", "lowdown", "ask"],
      stop_words: ["twitter", "twitters", "where", "bow"],
      handler_class: 'Handlers::Bio',
      response_kind: :message
    )
    Command.create(
      name: 'find',
      indicators: ["find", "dungeon", "maze", "where", "is"],
      stop_words: ["fact", "something", "about"],
      handler_class: 'Handlers::Item',
      handler_method: :find,
      response_kind: :message
    )
    Command.create(
      name: 'give',
      indicators: ["give", "hand", "to", "pass", "please"],
      stop_words: [],
      handler_class: 'Handlers::Item',
      handler_method: :give,
      response_kind: :message
    )
    Command.create(
      name: 'steal',
      verbs: ["steal"],
      stop_words: [],
      handler_class: 'Handlers::Item',
      handler_method: :steal,
      response_kind: :emote
    )
    Command.create(
      name: 'oh',
      indicators: ["what", "heard", "ohs", "word", "saying", "talking", "oh", "say", "talk", "hear", "up", "going on", "overheard", "OH"],
      stop_words: [],
      handler_class: 'Handlers::Oh',
      response_kind: :message
    )
    Command.create(
      name: 'factoid',
      indicators: ["tell", "something", "fact", "about", "random", "suprising", "hearing", "the word", "the lowdown", "the low-down"],
      stop_words: [],
      handler_class: 'Handlers::Factoid',
      response_kind: :message
    )
  end

end