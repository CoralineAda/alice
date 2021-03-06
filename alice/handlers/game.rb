module Handlers

  class Game

    include PoroPlus
    include Behavior::HandlesCommands

    def number_wang
      return unless message.sender.can_play_games?
      response = ""
      if Util::Randomizer.one_chance_in(16)
        3.times{message.sender.score_points}
        response << "That's the Number Wang triple bonus! "
        response << "The points go to #{message.sender_nick}. "
        response << "Let's rotate the board!"
      elsif Util::Randomizer.one_chance_in(8)
        message.sender.score_points
        response << "That's Number Wang! "
        response << "We like those decimals. " if message.trigger =~ /\./
        response << "The points go to #{message.sender_nick}.  "
      end
      message.response = response
    end

  end

end
