class Alice::Treasure

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name

  attr_accessor :message

  belongs_to :user

  def self.from(string)
    names = Alice::Parser::NgramFactory.new(string.gsub(/[^a-zA-Z0-9\_\ ]/, '')).omnigrams
    names = names.map{|g| g.join ' '}
    names.map{|name| Alice::Treasure.like(name) }.flatten.compact || []
  end

  def self.like(name)
    where(name: /#{name}/i)
  end

  def self.owner=(nick)
    treasure = first || create(user: User.random)
    treasure.user = Alice::User.like(nick)
    treasure.save
  end

  def transferable?
    self.message.nil?
  end

  def transfer_from(nick)
    return self if self.user && self.user.has_nick?(nick)
    self.message = "Only #{user.primary_nick.titleize} can pass the precious #{self.name}!" 
    self
  end

  def to(nick)
    recipient = Alice::User.find_or_create(nick)
    self.message = "You can't pass the #{self.name} to an imaginary friend." unless recipient
    if recipient.is_bot?
      self.message = "#{recipient.primary_nick} does not accept gifts."
    end
    if transferable?
      self.message = "#{owner} passes the #{self.name} to #{recipient.primary_nick.capitalize}."
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

