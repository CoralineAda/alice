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
          config.plugins.plugins = [
            Listeners::Core,
            Listeners::Setter,
            Listeners::Treasure,
            Listeners::Nlp,
            Listeners::Zork,
            Listeners::Beverage
          ]
          config.password = ENV['USER_PASS']
          config.messages_per_second = 1
        end
      end
    end

    def start
      self.bot.start && self.bot
    end 

    def exists?(nick)
      self.bot.user_list.find(nick)
    end

    def stop
      self.bot.stop
    end

  end

end

