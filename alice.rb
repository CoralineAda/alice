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
  'outgoing_token'   => ENV['SLACK_API_TOKEN'],
  'api_token'        => ENV['SLACK_API_TOKEN']
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
    Alice::Util::Logger.info "params = #{params}"
    payload = {'channel' => params['channel_name']}
    Alice::Util::Logger.info "payload = #{payload}"
    bot.post_message(parsed_output['text'], payload) unless parsed_output['text'] =~ /Message\:\:Message/
  end
end


# def post_message(text, options = {})
#   payload = {
#     username: @options['name'],
#     channel:  @options['channel'],
#     text:     text,
#     as_user:  true
#   }.merge(options)
#   payload[:channel] = payload[:channel].gsub(/^#?/, '#') # chat.postMessage needs leading # on channel
#   @api.join(payload[:channel])
#   @api.post_message(payload)
#   return nil # be quiet in webhook reply
# end
