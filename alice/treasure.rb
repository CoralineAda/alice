class Alice::Treasure

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :is_cursed, type: Boolean

  attr_accessor :message

  belongs_to :user
  belongs_to :place

  def self.unclaimed
    where(user_id: nil, place_id: nil)
  end

  def self.from(string)
    names = Alice::Parser::NgramFactory.new(string.gsub(/[^a-zA-Z0-9\_\ ]/, '')).omnigrams
    names = names.map{|g| g.join ' '}
    names.map{|name| Alice::Treasure.like(name) }.flatten.compact || []
  end

  def self.like(name)
    where(name: /^#{name}$/i)
  end

  def self.owner=(nick)
    treasure = first || create(user: User.random)
    treasure.user = Alice::User.like(nick)
    treasure.save
  end

  def self.list
    "Our collective treasures include #{all.map{|t| "the #{t.name}"}.to_sentence}.".gsub('the the', 'the')
  end

  def self.container
    [
      "worldy possessions include",
      "pockets contain",
      "treasures include",
      "stuff includes",
      "vast collection of rarities includes"
    ].sample
  end

  def drop
    self.place = Alice::Place.last
    self.user = nil
    self.save
  end

  def cursed?
    return self.is_cursed unless self.is_cursed.nil?
    self.update_attribute(:is_cursed, rand(5) == 1 ? true : false)
  end

  def drop_message(nick)
    [
      "#{self.name} falls clattering to the floor.",
      "#{self.name} is now resting on the ground.",
      "#{nick} drops the #{self.name}",
      "#{nick} discards the #{self.name}",
      "#{nick} drops the #{self.name} on the ground.",
      "#{nick} quietly places the #{self.name} on the floor.",
      "#{nick} puts the #{self.name} down.",
      "#{nick} gently puts the #{self.name} down."
    ].sample
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
      self.message = "#{recipient.primary_nick.capitalize} now possesses the #{self.name}."
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

