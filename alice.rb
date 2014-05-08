require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'cinch'
require 'dotenv'
require 'require_all'

Dotenv.load
Bundler.require
Mongoid.load!("config/mongoid.yml")

module Alice

  require_all 'alice'

  def self.start
    @@bot = Alice::Bot.new
    @@bot.start
  end

  def self.bot
    @@bot ||= Alice::Bot.new
  end

end
