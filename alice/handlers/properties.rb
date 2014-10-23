module Handlers

  class Properties

    include PoroPlus
    include Behavior::HandlesTriggers

    def get_property
      parser.parse!
      sanitized_property = property.to_s.gsub("_", " ")
      message.set_response("#{subject.proper_name}'s #{sanitized_property} is #{result}.")
    rescue
      message.set_response("I'm not sure I understand, can you say that another way?")
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
