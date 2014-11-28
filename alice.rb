require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'cinch'
require 'dotenv'
require 'require_all'
require 'raad'

Dotenv.load
Bundler.require
Mongoid.load!("config/mongoid.yml")

require_all 'alice'

module Alice

  def self.new
    Daemon.new(bot)
  end

  def self.bot
    @@bot ||= Alice::Bot.new
  end

  class Daemon

    attr_reader :bot

    def initialize(bot)
      @bot = bot
    end

    def start
      Raad::Logger.info("Daemon started. I LIVE!")
      self.bot.start
      Processor.awaken
   end

    def stop
      Processor.sleep
      Raad::Logger.info("Daemon stopped.")
    end
  end
end

Yummly.configure do |config|
  config.app_id = ENV['YUMMLY_APP_ID']
  config.app_key = ENV['YUMMLY_APP_KEY']
end

I18n.enforce_available_locales = false

