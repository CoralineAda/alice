module Handlers

  class Unknown

    include PoroPlus

    attr_accessor :message

    def self.process(message, method=:process)
      new(message: message).public_send(method)
    end

    def process
      message.response = "#{Alice::Util::Randomizer.exclamation} I have no idea what you are talking about."
      message
    end

  end

end
