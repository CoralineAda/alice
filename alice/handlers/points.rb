module Handlers

  class Points

    include PoroPlus
    include Behavior::HandlesCommands

    def give
      p subject
      if message.sender.award_point_to(subject)
        message.set_response(subject.check_score)
      else
        message.set_response("#{message.sender_nick} needs to let their points cannon cool down.")
      end
      message.set_response("Yay for #{command_string.content}!") if subject.nil?
      message.set_response("You'll go blind that way!") if subject == message.sender
    end

    def lottery
      if message.is_sudo?
        u = User.active.random
        if u == message.sender
          message.set_response("Aww, no winners this time.")
        else
          u.score_points(13)
          message.set_response("#{u.current_nick} gets 13 bonus points!")
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
