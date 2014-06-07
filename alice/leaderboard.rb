class Alice::Leaderboard

  def self.report
    top_ten = players[0..4]
    return "Nobody has scored any points yet!" if top_ten.empty?
    return top_ten.map{|player| "#{player.proper_name} is in #{Alice::Util::Sanitizer.ordinal(player.rank)} place with #{player.points}"}.to_sentence + "."
  end

  def self.players
    (User.where(:points.gt => 0) + Alice::Actor.where(:points.gt => 0)).sort_by(&:points).reverse
  end

end