require 'cinch'

module Alice

  module Listeners

    class Zork

      include Alice::Behavior::TracksActivity
      include Alice::Behavior::TracksActivity
      include Cinch::Plugin

      STOPWORDS = [
        'look',
        'get',
        'hide',
        'pick up',
        'reset',
        'forge',
        'destroy',
        'drink',
        'brew',
        'cookie',
        'pants',
        'help',
        'source',
        'bug'
      ]

      match /^\!(north)/i,     method: :move, use_prefix: false
      match /^\!(south)/i,     method: :move, use_prefix: false
      match /^\!(east)/i,      method: :move, use_prefix: false
      match /^\!(west)/i,      method: :move, use_prefix: false
      match /^\!go (north)/i,  method: :move, use_prefix: false
      match /^\!go (south)/i,  method: :move, use_prefix: false
      match /^\!go (east)/i,   method: :move, use_prefix: false
      match /^\!go (west)/i,   method: :move, use_prefix: false
      match /^\!look (north)/i,  method: :look_direction, use_prefix: false
      match /^\!look (south)/i,  method: :look_direction, use_prefix: false
      match /^\!look (east)/i,   method: :look_direction, use_prefix: false
      match /^\!look (west)/i,   method: :look_direction, use_prefix: false
      match /^\!look$/i,       method: :look, use_prefix: false
      match /^\!xyzzy/i,       method: :move_random, use_prefix: false
      match /^\!reset maze/i,  method: :reset_maze, use_prefix: false
      match /^\!(.+ .+)/,      method: :handle_tricksies, use_prefix: false

      def look_direction(channel_user, direction)
        if room = Alice::Place.current.neighbors.select{|r| r[:direction] == direction}.map{|r| r[:room]}.first
          message = room.view
        else
          message = "Yeah, that's a nice wall right there."
        end
        Alice::Util::Mediator.reply_to(channel_user, message)
      end

      def handle_tricksies(channel_user, command)

        verb = command.split[0]
        noun = command.split[1..-1].join(' ')
        
        return if STOPWORDS.include?(verb.gsub('!',''))

        if noun =~ /gazebo/
          message = "The gazebo kills you all!"
          Alice::Util::Mediator.reply_to(channel_user, message)
          reset_maze(channel_user, force=true)
          return
        elsif Alice::Place.current.description.include?(noun)
          message = Alice::Util::Randomizer.cant_touch_this(verb, noun)
          Alice::Util::Mediator.reply_to(channel_user, message)
        end
      end

      def look(channel_user)
        Alice::Util::Mediator.reply_to(channel_user, Alice::Place.current.describe)
      end

      def move(channel_user, direction)
        if Alice::Place.current.exits.include?(direction) 
          message = Alice::Place.go(direction)
        else
          message = "You cannot move #{direction}!"
        end
        Alice::Util::Mediator.reply_to(channel_user, message)
        if message =~ /eaten by a grue/i || message =~ /kills the grue/i
          reset_maze(nil, true)
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

      def reset_maze(channel_user=nil, force=false)
        if force || Alice::Util::Mediator.op?(channel_user)
          message = "Everything goes black and you feel like you are suddenly somewhere else!"  
          message << " Please wait while we regenerate the matrix."
          message << " #{Alice::Item.fruitcake.user.proper_name} has been given a special gift."
        end
        Alice::Util::Mediator.send_raw(message)
        Alice::Dungeon.reset!
      end

    end

  end

end
