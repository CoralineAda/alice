require 'cinch'

module Alice

  module Handlers

    class Fruitcake

      include Cinch::Plugin

      match /\!fruitcake/, method: :find_fruitcake, use_prefix: false
      match /\!fruitcake (.+)/, method: :fruitcake, use_prefix: false

      def fruitcake(m, who)
        message = Alice::Fruitcake.transfer.from(m.user.nick).to(who).message
        m.reply(message)
      end

      def find_fruitcake(m)
        return unless fruitcake = Alice::Fruitcake.last
        return unless fruitcake.user
        m.reply("#{fruitcake.owner} has had the fruitcake for #{fruitcake.elapsed_time}.")
      end

    end

  end

end