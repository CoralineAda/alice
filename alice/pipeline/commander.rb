module Pipeline
  class Commander

    def self.process(message)
      response = Message::Response.from(message).try(:response)
      Util::Sanitizer.filter_for(message.sender, response)
      message.response = response
      message
    end

  end
end