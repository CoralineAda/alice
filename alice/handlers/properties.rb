module Handlers

  class Properties

    include PoroPlus
    include Behavior::HandlesTriggers

    def get_property
      parser.parse
      sanitized_property = property.to_s.gsub("_", " ")
      if result
        message.response = result ? "#{result}." : "no."
      elsif subject = parser.this_subject
        message.response = subject.bio
      else
        message.response = "#{message.sender_nick}: #{response}"
      end
    rescue
      message.response = "I'm not sure I understand, can you say that another way?"
    end

    private

    def result
      subject.public_send(property)
    rescue
      "not known to me."
    end

    def subject
      parser.this_subject
    end

    def property
      parser.this_property
    end

  end

end
