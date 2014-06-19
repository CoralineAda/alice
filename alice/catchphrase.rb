class Catchphrase

  include Mongoid::Document

  field :text
  field :last_spoken_at, type: DateTime

  belongs_to :actor

  def self.sample
    catchphrase = sample.asc(:last_spoken_at).first
    catchphrase.touch && catchphrase
  end

  def touch
    update_attribute(:last_spoken_at, DateTime.now)
  end

end
