class Catchphrase

  include Mongoid::Document

  field :text
  field :last_spoken_at, type: DateTime

  belongs_to :actor

  def self.sample
    catchphrase = all.asc(:last_spoken_at)[0..-2].sample
    catchphrase.update_spoken_at && catchphrase
  end

  def update_spoken_at
    update_attribute(:last_spoken_at, DateTime.now)
  end

end
