require 'pry'

module Handlers

  class Dungeon

    include PoroPlus
    include Behavior::HandlesCommands

    def move
      if Place.current.has_exit?(direction)
        response = "#{message.sender_nick} dazedly leads the party #{direction}.\n\r" if message.sender.dazed?
        response = "#{message.sender_nick} staggers #{direction}.\n\r" if message.sender.drunk?
        response = "#{message.sender_nick} leads the party (hopefully) #{direction}.\n\r" if message.sender.disoriented?
        response ||= ""
        response << Place.go(direction)
      else
        response = "You can't go that way!"
      end
      message.set_response(response)
    end

    def look
      if direction.present?
        if Place.current.has_exit?(direction)
          room = Place.current.neighbors.select{|r| r[:direction] == direction}.first[:room]
          response = room.view
        elsif direction
          response = "A lovely wall you've found there."
        end
      elsif command_string.subject.length > 0 && subject = command_string.subject
        if obj = (::User.from(subject) || ::Item.from(subject) || ::Beverage.from(subject) || ::Machine.from(subject) || ::Actor.from(subject))
          response = obj.describe
        elsif Place.current.description =~ /#{command_string.subject}/i
          response = Alice::Util::Randomizer.item_description(command_string.subject)
        else
          response = "I don't see that here."
        end
      end
      response ||= Place.current.describe
      message.set_response(response)
    end

    def map
      message.set_response("#{ENV['MAP_URL']}")
    end


    def xyzzy
      room = Place.all.sample
      Place.set_current_room(room)
      response = "Everything spins around!\n\r"
      response << room.describe
      message.set_response(response)
    end

    def attack
      if command_string.subject =~ /darkness/ && Place.current.is_dark?
        message.set_response("You attack the darkness! A voice to the east whines, 'Where is the Mountain Dew?'")
      elsif command_string.subject =~ /gazebo/ && Place.current.description =~ /gazebo/
        response = "The gazebo kills you all!\n\r"
        response << reset_maze
        message.set_response(response)
      else
        message.set_response("That's not very nice.")
      end
    end

    private

    def direction
      @direction ||= ::Dungeon.direction_from(command_string.verb)
    end

    def reset_maze
      message.set_response(Dungeon.reset_maze)
    end

  end

end
