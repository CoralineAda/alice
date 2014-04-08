require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'cinch'
require 'dotenv'

Dotenv.load
Bundler.require
Mongoid.load!("config/mongoid.yml")

module Alice

  require_relative 'alice/handlers/bio'
  require_relative 'alice/handlers/factoid'
  require_relative 'alice/handlers/greeting'
  require_relative 'alice/handlers/twitter'
  require_relative 'alice/handlers/oh'
  require_relative 'alice/handlers/beverage_finder'
  require_relative 'alice/handlers/treasure_finder'
  require_relative 'alice/handlers/treasure_lister'
  require_relative 'alice/handlers/treasure_giver'
  require_relative 'alice/handlers/inventory'
  
  require_relative 'alice/listeners/setter'
  require_relative 'alice/listeners/beverage'
  require_relative 'alice/listeners/core'
  require_relative 'alice/listeners/nlp'
  require_relative 'alice/listeners/treasure'
  require_relative 'alice/listeners/zork'

  require_relative 'alice/parser/language_helper'
  require_relative 'alice/parser/ngram'
  require_relative 'alice/parser/ngram_factory'

  require_relative 'alice/beverage'
  require_relative 'alice/bot'
  require_relative 'alice/command'
  require_relative 'alice/factoid'
  require_relative 'alice/response'
  require_relative 'alice/treasure'
  require_relative 'alice/user'
  require_relative 'alice/greeting'
  require_relative 'alice/oh'
  require_relative 'alice/place'  
  
  def self.start
    @@bot = Alice::Bot.new
    @@bot.start
  end

  def self.bot
    @@bot ||= Alice::Bot.new
  end

end