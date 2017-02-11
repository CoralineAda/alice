module Pipeline
  class Commander

    def self.process(message)
      command, message = ::Message::Command.process(message)
      filtered_result = Util::Sanitizer.filter_for(message.sender, message.response.content)
      message.response = filtered_result
      message.response_type = command.response_kind
      message
    end

  end
end
