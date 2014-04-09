module Alice

  module Steals

    def check_score
      score_text = "#{self.proper_name} has #{self.points} points"
      score_text << " and is in #{place} place" if self.place < 4
      score_text << "."
      score_text
    end

    def score
      self.update_attribute(score: self.score + 1)
    end

    def penalize
      self.update_attribute(score: self.score - 1)
    end

  end

end