require 'cinch'

module Alice

  module Listeners

    class Zork

      include Cinch::Plugin

      match /^\!(north)/, method: :move, use_prefix: false
      match /^\!(south)/, method: :move, use_prefix: false
      match /^\!(east)/,  method: :move, use_prefix: false
      match /^\!(west)/,   method: :move, use_prefix: false
      match /^\!look/,     method: :look, use_prefix: false

      def move(m, direction)
        Alice::Place.go(direction) && message = "The party goes #{direction}. #{Alice::Place.last.describe}" || "#{m.user.nick}, you cannot move #{direction}!"
        m.reply(message)
      end

      def look(m)
        m.reply(Alice::Place.last.describe)
      end

    end

  end

end
