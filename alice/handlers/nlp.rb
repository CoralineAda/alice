require 'cinch'

module Alice

  module Handlers

    class Nlp

      include Cinch::Plugin

      match /\walice/i, method: :process, use_prefix: false
  
      def process(m, string_one, string_two)
        message = "#{string_one} #{string_2}"
        response = Alice::Command.parse(message) 
        response && response.kind == :reply && m.reply(response.content)
        response && response.kind == :action && m.action_reply(response.content)
      end    

    end

  end

end
