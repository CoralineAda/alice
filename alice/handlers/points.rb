module Handlers

  class Points

    include PoroPlus
    include Behavior::HandlesCommands

    def give
      if subject && message.sender.award_point_to(subject)
        message.set_response(subject.check_score)
      elsif subject.nil?
         message.set_response("Yay for #{command_string.content.gsub('++','')}!")
      elsif subject == message.sender
         message.set_response("You'll go blind that way!")
      else
        message.set_response("#{message.sender_nick} needs to let their points cannon cool down.")
      end
    end

    def lottery
      if message.is_sudo?
        u = User.active.random
        if u == message.sender
          message.set_response("Aww, no winners this time.")
        else
          points = rand(13) + 1
          u.score_points(points))
          message.set_response("#{u.current_nick} gets #{points} bonus points!")
        end
      end
    end

    def check
      message.set_response(message.sender.check_score)
    end

    def leaderboard
      message.set_response(Alice::Leaderboard.report)
    end

    private

    def subject
      ::User.from(command_string.content)
    end

  end

end
