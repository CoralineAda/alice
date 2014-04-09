class Alice::Bio

  include Mongoid::Document

  field :text

  belongs_to :user

  def self.random
    all.sample
  end

  def anonymized
    "This person #{self.text}"
  end

  def formatted
    "#{self.user.proper_name} #{self.text}"
  end

end