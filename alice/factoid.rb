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

  def formatted(with_prefix=true)
    message = ""
    message << "#{Alice::Util::Randomizer.fact_prefix}" if with_prefix
    message << " #{self.user.try(:proper_name)} #{self.text}"
    message
  end

end