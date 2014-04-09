class Alice::Leaderboard

  def self.report
    scored_players = players.sort{&:score}.reverse[0..9].select{|p| p.score > 0}
    return "Nobody has scored any points yet!" if scored_players.empty?
    return scored_players.map(&:proper_name)
  end

  def self.players
    Alice::Actor.all & Alice::User.all
  end

end