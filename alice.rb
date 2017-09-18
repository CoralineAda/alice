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
  'name'             => ENV['BOT_NAME'],
  'incoming_webhook' => ENV['INCOMING_WEBHOOK'],
  'outgoing_token'   => ENV['SLACK_API_TOKEN']
}

Yummly.configure do |config|
  config.app_id = ENV['YUMMLY_APP_ID']
  config.app_key = ENV['YUMMLY_APP_KEY']
end

I18n.enforce_available_locales = false

bot_interface_handler = Slackbotsy::Bot
# SLACK_API_TOKEN of 'xxx' is the .env.sample default
if ENV['SLACK_API_TOKEN'] == 'xxx' || ENV['USE_TESTBOTSY'] == 'true'
  bot_interface_handler = Testbotsy
end

bot = bot_interface_handler.new(config) do
  hear /(.+)/ do |mdata|
    begin
      name = User.ensure_user(user_name, user_id).primary_nick
      if message = Pipeline::Listener.new(name, mdata[1]).route
        {
          content: message.response.content,
          response_type: message.response_type
        }.to_json
      end
    rescue Exception => e
      Alice::Util::Logger.info "*** Unable to process \"#{mdata[1]}\": #{e}"
      Alice::Util::Logger.info e.backtrace
    end
  end
end

post '/' do
  if output = bot.handle_item(params)
    response = JSON.parse(output)
    if response["text"]
      parsed_response = JSON.parse(response["text"])
      raw_text = parsed_response["content"]
      if parsed_response["response_type"] == "emote"
        processed_text = "_#{raw_text}_"
      else
        processed_text = raw_text
      end
      bot.say(processed_text, {channel: params['channel_name'], mrkdwn: 'true'})
    end
  end
end

get "/map" do
  content_type = "image/svg+xml"
  headers 'Content-Type' => "image/svg+xml"
  Util::Mapper.map!
end
