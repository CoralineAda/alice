module Handlers

  class Game

    include PoroPlus
    include Behavior::HandlesCommands

    def number_wang
      return unless Alice::Util::Randomizer.one_chance_in(8)
      return unless message.sender.can_play_game?
      response = ""
      if Alice::Util::Randomizer.one_chance_in(3)
        3.times{message.sender.score_points}
        response << "That's the Number Wang triple bonus! "
        response << "The points go to #{message.sender_nick}. "
      else
        message.sender.score_points
        response << "That's Number Wang! "
        response << "We like those decimals. " if message.trigger =~ /\./
        response << "The points go to #{message.sender_nick}.  "
      end
      response << "Let's rotate the board!" if Alice::Util::Randomizer.one_chance_in(5)
      message.set_response(response)
    end

  end

end
