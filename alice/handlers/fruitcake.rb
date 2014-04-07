require 'cinch'

module Alice
  module Handlers
    class Fruitcake

      include Cinch::Plugin

      match /\!fruitcake (.+)/, method: :fruitcake, use_prefix: false

      def fruitcake(m, who)
        message = Alice::Fruitcake.original.from(m.user.nick).to(who).message
        m.reply(message)
      end

    end

  end

end