# FIXME
module Handlers

  class Emotes

    include PoroPlus
    include Behavior::HandlesCommands

    def cast
      message.set_response(Alice::Randomizer.spell_effect(message.sender_nick, command_string.predicate))
    end

    def help
      response = ""
      response << "For most things you can ask me or tell me something in plain English."
      response << "!bio sets you bio, !fact sets a fact about yourself, and !twitter sets your Twitter handle."
      response << "!look, !inventory, !forge, and !brew can come in handy sometimes."
      response << "Also: beware the fruitcake. You've been warned."
      message.set_response(response.join("\r\n"))
    end

    def source
      message.set_response("My source code is available at https://github.com/Bantik/alice")
    end

    def bug
      message.set_response("Please submit bug reports at https://github.com/Bantik/alice/issues")
    end

    def shifty
      message.set_response("#{message.sender_nick} is looking pretty shifty...")
    end

    def one_ring
      message.set_response("...and in the darkness bind them.")
    end

    def so_say_we_all
      message.set_response("So say we all!")
    end

  end

end
