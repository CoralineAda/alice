module Handlers

  class Properties

    include PoroPlus
    include Behavior::HandlesTriggers

    def get_property
      parser.parse
      sanitized_property = property.to_s.gsub("_", " ")
      if result
        message.response = result ? "#{result}." : "no."
      elsif subject
        message.response = subject.bio.formatted
      else
        message.response = "#{message.sender_nick}: #{response}"
      end
    rescue
      message.response = "I'm not sure I understand, can you say that another way?"
    end

    private

    def result
      @result ||= begin
        result = subject.public_send(property)
        if result == false
          "no"
        elsif result == true
          "yes"
        end
      end
    rescue
      "not known to me"
    end

    def subject
      @subject ||= parser.subject
    end

    def property
      parser.property
    end

  end

end
