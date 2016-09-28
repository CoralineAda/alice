require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'dotenv'
require 'require_all'
require 'slackbotsy'
require 'sinatra'
require 'open-uri'

Dotenv.load
Bundler.require
Mongoid.load!("config/mongoid.yml")

require_all 'alice'

module Alice
  class Server < Sinatra::Base

  def self.config
    config = {
      'channel'          => '#main',
      'name'             => 'alice',
      'api_token'        => ENV['SLACK_API_TOKEN']
    }
  end

  Slackbotsy::Bot.new(config) do
    hear /(.+)/ do |mdata|
      Pipeline::Listener::route(username, mdata[1])
    end
  end

end

Yummly.configure do |config|
  config.app_id = ENV['YUMMLY_APP_ID']
  config.app_key = ENV['YUMMLY_APP_KEY']
end

I18n.enforce_available_locales = false

Alice.bot
