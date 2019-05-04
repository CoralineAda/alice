require "open-uri"
require "nokogiri"

module Pipeline

  class Processor

    include PoroPlus

    attr_accessor :message, :response_method, :trigger

    def self.process(message, response_method)
      new(
        message: message,
        response_method: response_method,
        trigger: message.trigger
      ).react
    end

    def react
      track_sender
      should_respond? ? public_send(self.response_method) : message
    end

    def should_respond?
      return true if self.trigger[0] == "!"
      return true if self.trigger =~ /\+\+/ && self.trigger !~ /\s*c\+\+/i
      return true if self.trigger =~ /^[0-9\.\-]+/
      return false if self.trigger =~ /thank/i && self.trigger !~ /#{ENV['BOT_NAME']}/i && self.trigger !~ /#{User.bot.slack_id}/i
      return true if self.trigger =~ /#{ENV['BOT_NAME']}/i
      return true if self.trigger =~ /#{User.bot.slack_id}/i
      return true if self.trigger =~ /nice|good|kind|sweet|cool|great/i
      false
    end

    def respond
      if response = Pipeline::Commander.process(self.message).response
        Pipeline::Mediator.reply_with(response.content)
      end
      message
    end

    private

    def track_sender
      return unless self.message.sender_nick
      self.message.sender && self.message.sender.active!
    end

  end
end
