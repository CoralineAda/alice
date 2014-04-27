require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'cinch'
require 'dotenv'

Dotenv.load
Bundler.require
Mongoid.load!("config/mongoid.yml")

module Alice

  require_relative 'alice/behavior/emotes'
  require_relative 'alice/behavior/has_inventory'
  require_relative 'alice/behavior/ownable'
  require_relative 'alice/behavior/placeable'
  require_relative 'alice/behavior/scorable'
  require_relative 'alice/behavior/searchable'
  require_relative 'alice/behavior/steals'

  require_relative 'alice/filters/dazed'
  require_relative 'alice/filters/drunk'
  require_relative 'alice/filters/disoriented'

  require_relative 'alice/handlers/beverage'
  # require_relative 'alice/handlers/bio'
  # require_relative 'alice/handlers/factoid'
  # require_relative 'alice/handlers/greeting'
  # require_relative 'alice/handlers/inventory'
  # require_relative 'alice/handlers/oh'
  # require_relative 'alice/handlers/response'
  # require_relative 'alice/handlers/item_finder'
  # require_relative 'alice/handlers/item_giver'
  # require_relative 'alice/handlers/item_lister'
  # require_relative 'alice/handlers/twitter'

  require_relative 'alice/parser/language_helper'
  require_relative 'alice/parser/ngram'
  require_relative 'alice/parser/ngram_factory'

  require_relative 'alice/user'
  require_relative 'alice/action'
  require_relative 'alice/actor'
  require_relative 'alice/beverage'
  require_relative 'alice/bio'
  require_relative 'alice/bot'
  require_relative 'alice/catchphrase'
  require_relative 'alice/direct_command'
  require_relative 'alice/fuzzy_command'
  require_relative 'alice/command_string'
  require_relative 'alice/dungeon'
  require_relative 'alice/factoid'
  require_relative 'alice/item'
  require_relative 'alice/listener'
  require_relative 'alice/locator'
  require_relative 'alice/machine'
  require_relative 'alice/oh'
  require_relative 'alice/leaderboard'
  require_relative 'alice/place'

  require_relative 'alice/util/mediator'
  require_relative 'alice/util/randomizer'
  require_relative 'alice/util/sanitizer'

  def self.start
    @@bot = Alice::Bot.new
    @@bot.start
  end

  def self.bot
    @@bot ||= Alice::Bot.new
  end

end