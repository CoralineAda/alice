module Pipeline
  class Commander

    def self.process(message)
      ::Message::Command.process(message)
      filtered_result = Util::Sanitizer.filter_for(message.sender, message.response.content)
      message.response = filtered_result
      message
    end

  end
end
