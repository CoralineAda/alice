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
    return "It's #{self.user.proper_name}! " unless self.user.present?
    formatted_text = self.text.gsub(/^is /, ' ')
    formatted_text = "#{self.user.proper_name} is #{formatted_text}"
    formatted_text = formatted_text.gsub(/is (was|has|had|does|doesn.t) /, '\1 ')
    formatted_text = formatted_text.gsub(/[ ]+/, " ")
  end

end