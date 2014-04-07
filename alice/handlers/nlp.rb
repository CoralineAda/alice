require 'cinch'

module Alice

  module Handlers

    class Nlp

      include Cinch::Plugin

      match /(.?[ ]?alice.?)/i, method: :process, use_prefix: false

      def process(m, message)
        response = Alice::Command.parse(message) 
        p response
        response && response.kind == :reply && m.reply(response.content)
        response && response.kind == :action && m.action_reply(response.content)
      end    

    end

  end

end
