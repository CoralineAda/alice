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

config = {
  'channel'          => '#main',
  'name'             => 'alice',
  'incoming_webhook' => ENV['INCOMING_WEBHOOK'],
  'outgoing_token'   => ENV['SLACK_API_TOKEN']
}

Yummly.configure do |config|
  config.app_id = ENV['YUMMLY_APP_ID']
  config.app_key = ENV['YUMMLY_APP_KEY']
end

I18n.enforce_available_locales = false

bot = Slackbotsy::Bot.new(config) do
  hear /(.+)/ do |mdata|
    begin
      Alice::User.ensure_user(user_name)
      Pipeline::Listener.new.route(user_name, mdata[1])
    rescue
      ""
    end
  end
end

post '/' do
  if output = bot.handle_item(params)
    parsed_output = JSON.parse(output)
    bot.say(parsed_output['text']) unless parsed_output['text'] =~ /Message\:\:Message/
  end
end
