require "open-uri"
require "nokogiri"

class Processor

  include PoroPlus

  attr_accessor :channel, :message, :response_method, :trigger

  def self.process(channel, message, response_method)
    new(
      channel: channel,
      message: message,
      response_method: response_method,
      trigger: message.trigger
    ).react
  end

  def self.sleep
    Alice::Util::Mediator.emote(ENV['PRIMARY_CHANNEL'], "reboots.")
  end

  def react
    track_sender
    should_respond? ? public_send(self.response_method) : message
  end

  def should_respond?
    return true if self.trigger[0] == "!"
    return true if self.trigger =~ %r{(https?://.*?)(?:\s|$|,|\.\s|\.$)}
    return true if self.trigger =~ /\+\+/
    return true if self.trigger =~ /^[0-9\.\-]+$/
    return true if self.trigger =~ /well[,]* actually/i
    return true if self.trigger =~ /so say we all/i
    return true if self.trigger =~ /#{ENV['BOT_SHORT_NAME']}/i
    return true if self.response_method == :greet_on_join
    return true if self.response_method == :track_nick_change
    false
  end

  def respond
    if response = Alice::Commander.process(self.message).response
      if self.message.response_type == "emote"
        Alice::Util::Mediator.emote(self.channel, response)
      else
        Alice::Util::Mediator.reply_with(self.channel, response)
      end
    end
    message
  end

  def greet_on_join
    return unless Alice::Util::Randomizer.one_chance_in(4)
    Alice::Util::Mediator.emote(
      self.channel,
      Response.greeting(self.message).response
    )
    message
  end

  def track_nick_change
    user = User.find_or_create(message.sender_nick)
    user.update_nick(message.trigger)
    message
  end

  def preview_url
    Alice::Util::Mediator.reply_with(
      self.channel,
      Response.preview_url(self.message).response
    )
    message
  end

  def well_actually
    return unless Alice::Util::Randomizer.one_chance_in(2)
    Alice::Util::Mediator.reply_with(
      self.channel,
      Response.well_actually(self.message).response
    )
    message
  end

  def so_say_we_all
    Alice::Util::Mediator.reply_with(
      self.channel,
      Response.so_say_we_all(self.message).response
    )
    message
  end

  private

  def track_sender
    self.message.sender.active!
  rescue Exception => e
    puts "Could not track sender!"
  end

end
