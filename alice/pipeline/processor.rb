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
      return true if self.trigger =~ /^[0-9\.\-]+$/
      return true if self.trigger =~ /well[,]* actually/i
      return true if self.trigger =~ /so say we all/i
      return true if self.trigger =~ /#{ENV['BOT_SHORT_NAME']}/i
      false
    end

    def respond
      if response = Pipeline::Commander.process(self.message).response
        Alice::Util::Logger.info "*** response = #{response.content}"
        Alice::Util::Logger.info "*** processor response_type = #{response.response_type}"
#        persist_message
        if self.message.response_type == "emote"
          Pipeline::Mediator.emote(response.content)
        else
          Pipeline::Mediator.reply_with(response.content)
        end
      end
      message
    end

    private

    def persist_message
      if context = Context.current
        context.messages.create(Message::Serializer.serialize(message))
      end
    end

    def track_sender
      return unless self.message.sender_nick
      self.message.sender && self.message.sender.active!
    end

  end
end
