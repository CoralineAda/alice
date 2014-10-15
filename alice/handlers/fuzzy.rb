module Handlers

  class Fuzzy

    include PoroPlus
    include Behavior::HandlesCommands

    def get_property
      parser.parse!
      binding.pry
      message.set_response(subject.public_send(property))
    end

    private

    def subject
      parser.this_subject
    end

    def property
      parser.this_property
    end

    def parser
      Alice::Parser::Mash.new(message)
    end

  end

end
