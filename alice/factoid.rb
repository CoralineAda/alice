class Alice::Factoid

  include Mongoid::Document

  field :text

  belongs_to :user

  def self.for(nick)
    Alice::User.like(nick).try(:get_factoid)
  end

  def self.random
    all.sample
  end

  def formatted
    "#{Alice::Util::Randomizer.fact_prefix} #{self.user.try(:proper_name)} #{self.text}"
  end

end