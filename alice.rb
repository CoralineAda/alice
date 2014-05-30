require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'cinch'
require 'dotenv'
require 'require_all'

Dotenv.load
Bundler.require
Mongoid.load!("config/mongoid.yml")

require_all 'alice'

module Alice

  def self.start
    bot.start
  end

  def self.bot
    @@bot ||= Alice::Bot.new
    # @@bot.bot.loggers = nil
    @@bot
  end

end
