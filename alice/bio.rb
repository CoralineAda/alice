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
    return unless self.user.present?
    "#{self.user.proper_name} is #{self.text}"
  end

end