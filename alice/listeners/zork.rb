require 'cinch'

module Alice

  module Listeners

    class Zork

      include Cinch::Plugin

      match /^\!([north])/, method: :move, use_prefix: false
      match /^\!([south])/, method: :move, use_prefix: false
      match /^\!([east])/, method: :move, use_prefix: false
      match /^\!([west])/, method: :move, use_prefix: false
      match /^\!look/, method: :look, use_prefix: false
      match /^\!get (.+)/, method: :get, use_prefix: false
      match /^\!pick up (.+)/, method: :get, use_prefix: false
      match /^\!drop (.+)/, method: :drop, use_prefix: false
      match /^\!discard (.+)/, method: :drop, use_prefix: false

      def get(m, item)
        m.reply("You cannot get the #{item}!").gsub('the the', 'the') and return unless Alice::Place.last.contains?(item)
        m.reply(treasure.pickup_message(m.user.nick)) && item.to(m.user.nick)
      end

      def move(m, direction)
        Alice::Place.go(direction) && message = "The party goes #{direction}." || "#{m.user.nick}, you cannot move #{direction}!"
        m.reply(message)
      end

      def look(m)
        Alice::Place.last.describe
      end

    end

  end

end
