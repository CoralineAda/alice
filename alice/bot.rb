module Alice

  class Bot

    attr_accessor :bot

    def initialize
      self.bot = Cinch::Bot.new do
        configure do |config|
          config.server = "irc.lonelyhackersclub.com"
          config.port = 2600
          config.channels = ["##lonelyhackersclub", "##alicebottest"]
          config.nick = "AliceBot"
          config.user = "AliceBot"
          config.plugins.plugins = [Core, Bio]
          config.password = "blacksk13s14"
          config.messages_per_second = 1
        end
      end
    end

    def start
      self.bot.start && self.bot
    end 

    def stop
      self.bot.stop
    end

  end

end

