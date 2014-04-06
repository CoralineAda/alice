class Alice::Factoid

  include Mongoid::Document

  field :text

  belongs_to :user

  def sanitized
    sanitized = self.text
    sanitized = sanitized.gsub(/^I/i, '')
    sanitized = sanitized.gsub(/^am/i, 'is')

  end

  def formatted
    prefix = [
      "",
      "True story:",
      "I seem to recall that",
      "Rumor has it that",
      "Some believe that",
      "Some say",
      "It's been said that",
      "Legend says",
      "According to my notes,",
      "If the rumors are to be believed,",
      "Word on the street is that"
    ].sample
    "#{prefix} #{self.user.formatted_name} #{sanitized}".gsub(/[\.\!\?]$/, '.')
  end


end