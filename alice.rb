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
  'channel'          => '#main,#mudroom',
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
      name = User.ensure_user(user_name, user_id).primary_nick
      Pipeline::Listener.new.route(name, mdata[1])
    rescue Exception => e
      Alice::Util::Logger.info "*** Unable to process \"#{mdata[1]}\": #{e}"
      Alice::Util::Logger.info e.backtrace
    end
  end
end

post '/' do
  if output = bot.handle_item(params)
    parsed_output = JSON.parse(output)
    bot.say(parsed_output['text'], {channel: params['channel_name'], mrkdwn: 'true'}) unless parsed_output['text'] =~ /Message\:\:Message/
  end
end
