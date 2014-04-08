require 'cinch'

module Alice

  module Listeners

    class Zork

      include Cinch::Plugin

      match /^\!(north)/,     method: :move, use_prefix: false
      match /^\!(south)/,     method: :move, use_prefix: false
      match /^\!(east)/,      method: :move, use_prefix: false
      match /^\!(west)/,      method: :move, use_prefix: false
      match /^\!go (north)/,  method: :move, use_prefix: false
      match /^\!go (south)/,  method: :move, use_prefix: false
      match /^\!go (east)/,   method: :move, use_prefix: false
      match /^\!go (west)/,   method: :move, use_prefix: false
      match /^\!look/,        method: :look, use_prefix: false
      match /^\!xyzzy/,       method: :move_random, use_prefix: false
      match /^\!reset maze/,  method: :reset_maze, use_prefix: false

      def reset_maze(m, force=false)
        if m.channel.ops.map(&:nick).include?(m.user.nick) || force
          Alice::Place.reset_all!
          message = "Everything goes black and you feel like you are somewhere else!"  
        else
          message = "There is a thundering sound but nothing happens."
        end
        m.reply(message)
      end

      def move(m, direction)
        Alice::Place.go(direction) && message = "The party goes #{direction}. #{Alice::Place.last.describe}"
        message ||= "You cannot move #{direction}!"
        m.reply(message)
        reset_maze('nobody', true) if Alice::Place.last.has_grue?
      end

      def move_random(m)
        m.reply("Nothing happens.") unless rand(10) == 1
        Alice::Place.random 
        place = Alice::Place.last
        if place.has_grue?
          message = "You have been eaten by a grue!"
          reset_maze('nobody', true) if Alice::Place.last.has_grue?
        else
          message = "You find yourself in #{Alice::Place.last.describe}"
        end
        m.reply(message)
      end

      def look(m)
        m.reply(Alice::Place.last.describe)
      end

    end

  end

end
