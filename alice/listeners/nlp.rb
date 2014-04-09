require 'cinch'

module Alice

  module Listeners

    class Nlp

      include Alice::Behavior::TracksActivity
      include Alice::Behavior::TracksActivity
      include Cinch::Plugin

      match /(.*[ ]?alice.*)/i, method: :process, use_prefix: false

      def process(channel_user, message)
        response = Alice::Command.parse(channel_user.user.nick, message) 
        response && response.kind == :reply && Alice::Util::Mediator.reply_to(channel_user, response.content)
        response && response.kind == :action && Alice::Util::Mediator.emote_to(channel_user, response.content)
      end    

    end

  end

end
