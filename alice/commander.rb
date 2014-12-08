module Alice

  class Commander

    def self.process(message)
      response = Response.from(message).try(:response)
      Alice::Util::Sanitizer.filter_for(message.sender, response)
      message.response = response
      message
    end

  end

end