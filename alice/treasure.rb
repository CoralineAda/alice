class Alice::treasure

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  attr_accessor :message

  belongs_to :user

  def self.owner
    treasure = first || create(user: User.random)
    treasure.owner
  end

  def self.owner=(nick)
    treasure = first || create(user: User.random)
    treasure.user = Alice::User.like(nick)
    treasure.save
  end

  def transferable?
    self.message.nil?
  end

  def transfer_from(name)
    return self if self.user && self.user.has_nick?(name)
    self.message = "Only #{user.primary_nick.titleize} can pass the sacred treasure!" 
    self
  end

  def to(name)
    self.message = "You can't pass #{name.pluralize} to imaginary friends." unless recipient = Alice::User.find_or_create(name)
    if transferable?
      self.message = "#{owner} passes the #{name} to #{recipient.primary_nick.capitalize}."
      self.user = recipient
      self.save
    end
    self
  end
  
  def owner
    self.user.primary_nick.capitalize
  end

  def elapsed_time
    hours = (Time.now.minus_with_coercion(self.updated_at)/3600).round
    elapsed = hours < 1 && "a short while"
    elapsed ||= hours < 24 && "less than a day"
    elapsed ||= hours / 24 == 1 ? "one day" : "#{hours / 24} days"
    elapsed
  end

end

