class Alice::Oh

  include Mongoid::Document

  field :text

  def self.random
    all.sample
  end

  def formatted
    "#{prefix} #{text}".gsub('  ',' ')
  end

  def prefix
    [
      "Some say that",
      "I heard recently that",
      "Someone said that",
      "It's been said that"
    ].sample
  end

end