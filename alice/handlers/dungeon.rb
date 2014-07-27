require 'pry'

module Handlers

  class Dungeon

    include PoroPlus
    include Behavior::HandlesCommands

    def move
      if Place.current.has_exit?(direction)
        response = "#{message.sender_nick} dazedly leads the party #{direction}.\n\r" if user.dazed?
        response = "#{message.sender_nick} staggers #{direction}.\n\r" if user.drunk?
        response = "#{message.sender_nick} leads the party (hopefully) #{direction}.\n\r" if user.disoriented?
        response ||= ""
        response << Place.go(direction)
      else
        response << "You can't go that way!"
      end
      message.set_response(response)
    end

    def look
      response = ""
      if direction
        if Place.current.has_exit?(direction)
          room = Place.current.neighbors.select{|r| r[:direction] == direction}.first[:room]
          response = room.view
        else direction
          response = "A lovely wall you've found there."
        end
      elsif command_string.subject.length > 0 && subject = command_string.subject
        if obj = (User.from(subject) || Item.from(subject) || Beverage.from(subject) || Machine.from(subject))
          response = obj.describe
        else
          response = "I don't see that here."
        end
      else
        response = Place.current.describe
      end
      message.set_response(response)
    end

    def xyzzy
      room = Place.random
      set_current_room(room)
      response = "Everything spins around!\n\r"
      response << room.describe
      message.set_response(response)
    end

    def gazebo
      response = "The gazebo kills you all!\n\r"
      response << reset_maze
      message.set_response(response)
      reset_maze
    end

    private

    def direction
      @direction ||= ::Dungeon.direction_from(command_string.subject)
    end

    def reset_maze
      response = ""
      response << "Everything goes black and you feel like you are suddenly somewhere else!\n\r"
      response << "Please wait while we regenerate the matrix...\n\r"
      Dungeon.reset!
      response << "#{Item.fruitcake.user.proper_name} has been given a special gift.\n\r"
      response << Alice::Place.current.describe
      response
    end

  end

end
