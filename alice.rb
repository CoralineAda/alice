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
  require_relative 'alice/bio'
  require_relative 'alice/core'
  require_relative 'alice/user'
  require_relative 'alice/factoid'

  def self.start
    @@bot = Alice::Bot.new
    @@bot.start
  end

end