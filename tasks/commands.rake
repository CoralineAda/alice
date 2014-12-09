require './alice'

namespace :commands do

  desc "Import commands"
  task :import do
    system 'ruby db/commands/import.rb'
  end

  desc "Export existing commands"
  task :export do

    File.open('db/commands/import.rb', 'w') do |file|
      file.puts ("require_relative '../../alice'")
      Message::Command.all.each do |command|
        next unless command.name
        output = []
        output << "Message::Command.create("
        output << "\tname: '#{command.name}',"
        output << "\tverbs: #{command.verbs},"
        output << "\tstop_words: #{command.stop_words},"
        output << "\tindicators: #{command.indicators},"
        output << "\thandler_class: '#{command.handler_class}',"
        output << "\thandler_method: '#{command.handler_method}',"
        output << "\tresponse_kind: '#{command.response_kind}',"
        output << ")"
        output = output.join("\n")
        file.puts output
      end
      file.puts "puts 'Command import complete.'"
    end

  end

  desc "Create default commands"
  task :create_defaults do

    # Actor handler

    Message::Command.create(
      name: 'summon',
      verbs: ["summon", "invite", "call"],
      stop_words: [],
      handler_class: 'Handlers::Actor',
      handler_method: :summon,
      response_kind: :message
     )

    Message::Command.create(
      name: 'talk',
      verbs: ["talk", "chat", "ask"],
      stop_words: [],
      handler_class: 'Handlers::Actor',
      handler_method: :talk,
      response_kind: :message
     )

    Message::Command.create(
      name: 'brew',
      verbs: ["brew", "distill", "pour"],
      stop_words: [],
      handler_class: 'Handlers::Beverage',
      handler_method: :brew,
      response_kind: :emote
    )
    Message::Command.create(
      name: 'beverage',
      verbs: ["pour","drink","quaff","sip","swallow","gulp","down","chug"],
      stop_words: [],
      handler_class: 'Handlers::Beverage',
      handler_method: :drink,
      response_kind: :emote
    )
    Message::Command.create(
      name: 'twitter',
      indicators: ["twitter", "handle", "nick", "who", "what", "handl"],
      stop_words: [],
      handler_class: 'Handlers::Twitter',
      response_kind: :message
    )
    Message::Command.create(
      name: 'greeting',
      indicators: ["hi", "hello", "hey", "heya", "o/", "\\o", "greetings", "greets", "greet", "morning", "afternoon", "evening", "mornin", "morgen", "dias", "tagen", "evenin", "love", "hate", "hug"],
      stop_words: [],
      handler_class: 'Handlers::Greeting',
      response_kind: :message
    )
    Message::Command.create(
      name: 'inventory',
      indicators: ["inventory", "pockets", "purse", "satchel", "backpack", "back pack", "bag", "holding", "stuff", "carry", "inventori", "pocket", "purs", "hold", "carri", "what"],
      stop_words: [],
      handler_class: 'Handlers::Inventory',
      response_kind: :message
    )
    Message::Command.create(
      name: 'bio',
      indicators: ["tell", "about", "something", "who", "is", "someth", "low-down", "lowdown", "ask"],
      stop_words: ["twitter", "twitters", "where", "bow"],
      handler_class: 'Handlers::Bio',
      response_kind: :message
    )
    Message::Command.create(
      name: 'find',
      indicators: ["find", "dungeon", "maze", "where", "is"],
      stop_words: ["fact", "something", "about"],
      handler_class: 'Handlers::Item',
      handler_method: :find,
      response_kind: :message
    )
    Message::Command.create(
      name: 'give',
      indicators: ["give", "hand", "to", "pass", "please"],
      stop_words: [],
      handler_class: 'Handlers::Item',
      handler_method: :give,
      response_kind: :message
    )
    Message::Command.create(
      name: 'steal',
      verbs: ["steal"],
      stop_words: [],
      handler_class: 'Handlers::Item',
      handler_method: :steal,
      response_kind: :emote
    )
    Message::Command.create(
      name: 'oh',
      indicators: ["what", "heard", "ohs", "word", "saying", "talking", "oh", "say", "talk", "hear", "up", "going on", "overheard", "OH"],
      stop_words: [],
      handler_class: 'Handlers::Oh',
      response_kind: :message
    )
    Message::Command.create(
      name: 'factoid',
      indicators: ["tell", "something", "fact", "about", "random", "suprising", "hearing", "the word", "the lowdown", "the low-down"],
      stop_words: [],
      handler_class: 'Handlers::Factoid',
      response_kind: :message
    )
  end

end