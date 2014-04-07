class Alice::Factoid

  include Mongoid::Document

  field :text

  belongs_to :user

  def self.minimum_indicators
    2
  end

  def self.process(sender, command)
    if subject = command.split(/[^a-zA-Z0-9\_]/).map{|name| Alice::User.like(name) }.compact.sample
      if factoid = subject.factoids.sample
        Alice::Response.new(content: factoid.formatted, kind: :reply)
      end
    else
      Alice::Response.new(content: random, kind: :reply)
    end
  end

  def self.random
    all.sample
  end

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