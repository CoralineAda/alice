class Alice::Factoid

  include Mongoid::Document

  field :text

  belongs_to :user

  def sanitized
    sanitized = self.text
    sanitized = sanitized.gsub(/^I/i, '')
    sanitized = sanitized.gsub(/^am/i, '')
  end

end