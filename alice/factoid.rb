class Alice::Factoid

  include Mongoid::Document

  field :text

  belongs_to :user

  def self.for(nick)
    return unless user = Alice::User.like(nick)
    user.get_factoid
  end

  def sanitized
    sanitized = self.text
    sanitized = sanitized.gsub(/^I /i, '')
    sanitized = sanitized.gsub(/^am/i, 'is')
    sanitized = sanitized.gsub(/[\.\!\?]$/, '.')
    sanitized
  end

  def formatted
    "#{prefix} #{self.user.formatted_name} #{sanitized}"
  end

  def prefix
    [
      "",
      "True story:",
      "I seem to recall that",
      "Rumor has it that",
      "Some believe that",
      "Some say",
      "It's been said that",
      "Legend says that",
      "According to my notes,",
      "If the rumors are to be believed,",
      "Word on the street is that"
    ].sample
  end


end