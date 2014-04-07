require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'cinch'
require 'dotenv'

Dotenv.load
Bundler.require
Mongoid.load!("config/mongoid.yml")

module Alice
  require_relative 'alice/bot'
  require_relative 'alice/handlers/bio'
  require_relative 'alice/handlers/core'
  require_relative 'alice/handlers/fruitcake'
  require_relative 'alice/user'
  require_relative 'alice/factoid'

  def self.start
    @@bot = Alice::Bot.new
    @@bot.start
  end

  def self.bot
    @@bot ||= Alice::Bot.new
  end

end