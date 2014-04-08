class Alice::Treasure

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :is_cursed, type: Boolean
  field :is_hidden, type: Boolean

  validates_uniqueness_of :name
  
  attr_accessor :message

  belongs_to :user
  belongs_to :place

  def self.reset_hidden!
    hidden.map(&:delete)
    Alice::Treasure.unclaimed.like('bow and arrow').delete
  end

  def self.generate_bow
    descriptor = ["wooden", "golden", "silver", "bronze", "platinum", "titanium"].sample
    Alice::Treasure.create(name: "#{descriptor} bow and arrow", place: Alice::Place.last)
  end

  def self.unclaimed
    where(user_id: nil, place_id: nil)
  end

  def self.hidden
    excludes(place_id: nil)
  end

  def self.claimed
    excludes(user_id: nil)
  end

  def self.from(string)
    names = Alice::Parser::NgramFactory.new(string.gsub(/[^a-zA-Z0-9\_\ ]/, '')).omnigrams
    names = names.map{|g| g.join ' '}
    names.map{|name| Alice::Treasure.like(name) }.flatten.compact || []
  end

  def self.like(name)
    where(name: /#{name}$/i)
  end

  def self.owner=(nick)
    treasure = first || create(user: User.random)
    treasure.user = Alice::User.like(nick)
    treasure.save
  end

  def self.list
    string = ""
    string << "Our collective treasures include #{claimed.map{|t| "the #{t.name}"}.to_sentence}." if claimed.count > 0
    string << "Somewhere in the labyrinth you may find #{unclaimed.map{|t| "the #{t.name}"}.to_sentence}." if unclaimed.count > 0
    string.gsub('the the', 'the')
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

  def hide(nick)
    self.place = Alice::Place.random
    self.user = nil
    self.is_hidden = true
    self.save
    hide_message(nick)
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

  def hide_message(nick)
    [
      "#{nick} places the #{self.name} somewhere deep in the labyrinth.",
      "#{nick} hides the #{self.name} somewhere deep in the labyrinth.",
      "#{nick} has hidden the #{self.name}.",
      "#{nick} throws the #{self.name} into the dungeon.",
      "#{nick} hides the #{self.name}.",
      "The #{self.name} is now hidden in the depths of the labyrinth.",
      "Who will be the first to find the #{self.name}?"
    ].sample.gsub("the the", "the").gsub("the ye", "ye")
  end

  def pickup_message(nick)
    [
      "#{nick.capitalize} pockets the #{self.name}.",
      "The #{self.name} now belongs to #{nick}!",
      "#{nick.capitalize} now has the #{self.name}.",
      "Now #{nick}'s #{Alice::Treasure.container} the #{self.name}."
    ].sample.gsub(/the the/i, 'the').gsub(/the ye/i, 'ye')
  end

  def drop_message(nick)
    [
      "The #{self.name} falls clattering to the floor.",
      "The #{self.name} is now resting on the ground.",
      "#{nick} drops the #{self.name}",
      "#{nick} discards the #{self.name}",
      "#{nick} drops the #{self.name} on the ground.",
      "#{nick} quietly places the #{self.name} on the floor.",
      "#{nick} puts the #{self.name} down.",
      "#{nick} gently puts the #{self.name} down."
    ].sample.gsub(/the the/i, 'the').gsub(/the ye/i, 'ye')
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
    if recipient = Alice::User.find_or_create(nick)
      if recipient.is_bot?
        self.message = "#{recipient.primary_nick} does not accept gifts."
      end
      if transferable?
        self.message = "#{recipient.primary_nick.capitalize} now possesses the #{self.name}."
        self.user = recipient
        self.save
      end
    else
      self.message = "You can't pass the #{self.name} to an imaginary friend." unless recipient
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

