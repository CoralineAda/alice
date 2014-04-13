require 'cinch'

module Alice

  module Listeners

    class Zork

      include Alice::Behavior::Listens
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

      match /^\!(north)/i,        method: :move, use_prefix: false
      match /^\!(south)/i,        method: :move, use_prefix: false
      match /^\!(east)/i,         method: :move, use_prefix: false
      match /^\!(west)/i,         method: :move, use_prefix: false
      match /^\!go (north)/i,     method: :move, use_prefix: false
      match /^\!go (south)/i,     method: :move, use_prefix: false
      match /^\!go (east)/i,      method: :move, use_prefix: false
      match /^\!go (west)/i,      method: :move, use_prefix: false
      match /^\!look (north)/i,   method: :look_direction, use_prefix: false
      match /^\!look (south)/i,   method: :look_direction, use_prefix: false
      match /^\!look (east)/i,    method: :look_direction, use_prefix: false
      match /^\!look (west)/i,    method: :look_direction, use_prefix: false
      match /^\!look$/i,          method: :look, use_prefix: false
      match /^\!teleport (.+)$/i, method: :teleport, use_prefix: false
      match /^\!xyzzy/i,          method: :move_random, use_prefix: false
      match /^\!reset maze/i,     method: :reset_maze, use_prefix: false
      match /^\!(.+ .+)/,         method: :handle_tricksies, use_prefix: false

      def look_direction(channel_user, direction)
        here = Alice::Place.current
        if room = here.neighbors.select{|r| r[:direction] == direction}.map{|r| r[:room]}.first
          if here.has_locked_door? && here.exit_is_locked?(direction)
            message = "You can't see past the big, locked door to the #{direction}."
          else
            message = room.view
          end
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
        here = Alice::Place.current
        if here.exits.include?(direction) 
          if here.exit_is_locked?(direction)
            message = "The door to the #{direction} is locked tight! "
            if user_with_key = (Alice::User.with_key & Alice::User.active_and_online).sample
              here.unlock
              message << "Luckily #{user_with_key.proper_name} was able to unlock it with #{user_with_key.items.keys.first.name_with_article}. "
              message << Alice::Place.go(direction)
            end
          else
            user = current_user_from(channel_user)
            message = "#{user.proper_name} dazedly leads the party #{direction}. " if user.dazed?
            message = "#{user.proper_name} staggers #{direction}. " if user.drunk?
            message = "#{user.proper_name} leads the party (hopefully) #{direction}. " if user.disoriented?
            message ||= ""
            message << Alice::Place.go(direction)
          end
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

      def teleport(channel_user, coords)
        x, y = coords.split(',')
        if Alice::Util::Mediator.op?(channel_user)
          if place = Alice::Place.where(x: x, y: y).visited.first
            Alice::Place.set_current_room(place)
            message = place.describe
            Alice::Util::Mediator.reply_to(channel_user, message)
          end
        else
          message = "Nice try, #{channel_user.use.nick}!"
        end
      end

    end

  end

end
