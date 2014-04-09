require 'cinch'

module Alice

  module Listeners

    class Zork

      include Alice::Behavior::TracksActivity
      include Alice::Behavior::TracksActivity
      include Cinch::Plugin

      match /^\!(north)/,     method: :move, use_prefix: false
      match /^\!(south)/,     method: :move, use_prefix: false
      match /^\!(east)/,      method: :move, use_prefix: false
      match /^\!(west)/,      method: :move, use_prefix: false
      match /^\!go (north)/,  method: :move, use_prefix: false
      match /^\!go (south)/,  method: :move, use_prefix: false
      match /^\!go (east)/,   method: :move, use_prefix: false
      match /^\!go (west)/,   method: :move, use_prefix: false
      match /^\!look$/,       method: :look, use_prefix: false
      match /^\!look (.+)$/,  method: :examine, use_prefix: false
      match /^\!inspect (.+)$/,  method: :examine, use_prefix: false
      match /^\!examine (.+)$/,  method: :examine, use_prefix: false
      match /^\!(.+ .+)/,     method: :handle_tricksies, use_prefix: false
      match /^\!xyzzy/,       method: :move_random, use_prefix: false
      match /^\!reset maze/,  method: :reset_maze, use_prefix: false

      def reset_maze(channel_user, force=false)
        if force || m && m.channel.ops.map(&:nick).include?(channel_user.user.nick)
          Alice::Place.reset_all!
          message = "Everything goes black and you feel like you are somewhere else!"  
        else
          message = "There is a thundering sound but nothing happens."
        end
      end

      def handle_tricksies(channel_user, command)

        verb = command.split[0]

        return if verb == 'look'
        return if verb == 'get'
        return if verb == 'pick up'
        return if verb == 'reset'
        return if verb == 'forge'
        return if verb == 'destroy'
        return if verb == 'drink'
        return if verb == 'brew'

        noun = command.split[1..-1].join(' ')

        if Alice::Place.current.description.include?(noun) && user = Alice::User.from(noun).last
          message = "What would #{user.primary_nick} have to say about that?"
        end

        return if noun.empty?
        
        if Alice::Place.current.description.include?(noun)
          message ||= [
            "You can't go around #{verb}ing #{noun}s all willy-nilly.",
            "Issues much?",
            "The #{noun} is NOT amused.",
            "While that may be technically possible, it is ill advised.",
            "I can't let you do that.",
            "Um, let's say no?",
            "That #{noun} will hurt you if you're not careful.",
            "Let's do something else instead.",
            "Shouldn't you be hunting the grue instead of messing around with #{noun.pluralize}?",
            "It's been established that if you #{verb} #{noun.pluralize}, you are likely to attract a grue.",
            "I'm not sure that you should really #{verb} a #{noun}.",
            "Are you saying that a #{noun} is a clown here for your amusement?",
            "Fine, if I let you #{verb} the #{noun} can we get on with our lives?",
            "She who #{verb.pluralize} the #{noun} must also #{verb} herself.",
            "It's a crazy world where people go around #{verb}ing all the #{noun.pluralize} they see.",
            "Next thing you know you'll be asking to #{verb} the grue!",
            "I didn't peg you for a '#{noun}' person.",
            "Do you always go around #{verb}ing things?"
          ].sample
        end
        Alice::Util::Mediator.reply_to(channel_user, message)
      end

      def examine(channel_user, thing)

        if Alice::Place.current.description.include?(thing) && user = Alice::User.from(thing.downcase).last
          message = 
            [
              "That's #{user.primary_nick} alright.",
              "Sure looks like #{user.primary_nick} to me.",
              "Spitting image of #{user.primary_nick} right there.",
              "It's #{user.primary_nick} all right!",
              "I can definitely see a resemblance to #{user.primary_nick}.",
            ].sample
        end

        if Alice::Place.current.description.include?(thing)
          message ||= Alice::Randomizer.description(thing)
        else
          message ||= [
            "I don't see such a thing as #{thing} here.",
            "I... think you're hallucinating.",
            "Yeah, about that invisible thing you're asking about...",
            "You could have sworn that you saw that #{thing} but it's not there now!"
          ].sample
        end
        Alice::Util::Mediator.reply_to(channel_user, message)
      end

      def move(channel_user, direction)
        if Alice::Place.go(direction)
          message = "#{Alice::Place.current.describe}"
        else
          message = "You cannot move #{direction}!"
        end
        Alice::Util::Mediator.reply_to(channel_user, message)
        if message =~ /eaten by a grue/i || message =~ /kills the grue/i
          message = reset_maze(Alice.bot.bot.nick, true)
          Alice::Util::Mediator.reply_to(channel_user, message)
        end
      end

      def move_random(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, "Nothing happens.") and return unless rand(10) == 1
        place = Alice::Place.random 
        message = "When the room stops spinning... #{Alice::Place.current.describe}"
        Alice::Util::Mediator.reply_to(channel_user, message)
        if message =~ /eaten by a grue/i
          message = reset_maze(Alice.bot.bot.nick, true)
          Alice::Util::Mediator.reply_to(channel_user, message)
        end
      end

      def look(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, Alice::Place.current.describe)
      end

    end

  end

end
