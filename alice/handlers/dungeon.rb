require 'pry'

module Handlers

  class Dungeon

    include PoroPlus
    include Behavior::HandlesCommands

    def move
      if Place.current.has_exit?(movement_direction)
        response = "#{message.sender_nick} dazedly leads the party #{movement_direction}.\n\r" if message.sender.dazed?
        response = "#{message.sender_nick} staggers #{movement_direction}.\n\r" if message.sender.drunk?
        response = "#{message.sender_nick} leads the party (hopefully) #{movement_direction}.\n\r" if message.sender.disoriented?
        response ||= ""
        response << Place.go(movement_direction)
      else
        response = "You can't go that way!"
      end
      message.response = response
    end

    def look
      subject = command.subject || ""
      Alice::Util::Logger.info "*** Look subject is \"#{command.subject}\""
      response = look_in_direction(looking_direction) if looking_direction.present?
      response = describe_setting(subject) if Place.current.description =~ /#{subject}/i
      response ||= subject.describe if subject.is_a? User
      response ||= extant_object(subject).try(:describe)
      response ||= extant_object(command_string.fragment).try(:describe)
      response ||= extant_object(command.predicate).try(:describe)
      response ||= Place.current.describe if subject.empty?
      response ||= "I don't see that here."
      message.response = response
    end

    def map
      message.response = "You can find an up-to-date map of the dungeon at #{ENV['MAP_URL']}. Your current location is highlighted in red. Be sure to mouse over the rooms!"
    end

    def xyzzy
      room = Place.all.sample
      Place.set_current_room(room)
      response = "Everything spins around!\n\r"
      response << room.describe
      message.response = response
    end

    def attack
      if command.subject =~ /darkness/ && Place.current.is_dark?
        message.response = "You attack the darkness! A voice to the east whines, 'Where is the Mountain Dew?'"
      elsif command.subject =~ /gazebo/# && Place.current.description =~ /gazebo/
        response = "The dread gazebo kills you all!\n\r"
        response << reset_maze
        message.response = response
      else
        message.response = Util::Randomizer.attack
      end
    end

    private

    def describe_setting(aspect)
      return unless aspect.present?
      Util::Randomizer.item_description(aspect)
    end

    def looking_direction
      @look_direction ||= ::Dungeon.direction_from(command.predicate)
    end

    def look_in_direction(direction)
      if Place.current.has_exit?(direction)
        response = Place.place_to(direction, party_moving=false, create_place=true).view_from_afar
      else
        response = "A lovely wall you've found there."
      end
    end

    def movement_direction
      @movement_direction ||= ::Dungeon.direction_from(command_string.verb)
    end

    def extant_object(name)
      return if name.empty?
      if actor = ::Actor.from(name)
        actor = Place.current.actors.include?(actor) ? actor : nil
      end
      (::User.from(name) || ::Item.from(name) || ::Beverage.from(name) || actor)
    end

    def reset_maze
      message.response = ::Dungeon.reset!
    end

  end
end
