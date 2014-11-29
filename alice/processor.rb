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
    if response = self.message.response
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
    Alice::Util::Mediator.emote(
      self.channel,
      Response.name_change(self.message).response
    )
    message
  end

  def preview_url
    source = Nokogiri::HTML(open(trigger))
    title_node = source.search("//title")
    source.search("//p").map(&:content).each do |content|
      next if content.length < 25
      snippet ||= ""; snippet << content[0..254]
      break if snippet.length > 255
    end
    snippet = snippet.to_s.strip.gsub(/[\n\r ]+/," ")[0..254]
    preview = "#{title_node && title_node.text}... #{snippet}..."
    Alice::Util::Mediator.reply_with(
      self.channel,
      Response.url_preview(self.message, preview).response
    )
  rescue Exception => e
    Alice::Util::Logger.info("*** Couldn't process URL preview for #{trigger}: #{e}")
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
  end

end
