module Handlers

  class Points

    include PoroPlus
    include Behavior::HandlesCommands

    def give
      if subject == message.sender
         message.response = "You'll go blind that way!"
      elsif subject && message.sender.award_point_to(subject)
        message.response = subject.check_score
      elsif subject.nil?
        this = command_string.content.gsub('++','')
        message.response = "Yay for #{this}!"
      else
        message.response = "#{message.sender_nick} needs to let #{message.sender.pronoun_possessive} points cannon cool down."
      end
    end

    def lottery
      if message.is_sudo?
        u = User.active.random
        if u == message.sender
          message.response = "Aww, no winners this time."
        else
          points = rand(13) + 1
          u.score_points(points)
          message.response = "#{u.primary_nick} gets #{points} bonus points!"
        end
      end
    end

    def check
      message.response = message.sender.check_score
    end

    def leaderboard
      message.response = Alice::Leaderboard.report
    end

    private

    def subject
      ::User.from(command_string.components.map{|c| c.gsub("++", "")}.join(' '))
    end

  end

end
