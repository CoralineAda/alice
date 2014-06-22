module Handlers

  class Unknown

    attr_accessor :message, :method, :raw_command

    def process
      message.response = "#{Alice::Util::Randomizer.exclamation} I have no idea what you are talking about."
    end

  end

end
