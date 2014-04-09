class Alice::User

  include Mongoid::Document
  include Alice::Behavior::Searchable

  field :primary_nick
  field :alt_nicks, type: Array, default: []
  field :bio
  field :twitter_handle
  field :last_theft, type: DateTime
  field :is_bot, type: Boolean, default: false

  has_many :factoids
  has_many :treasures
  has_many :beverages

  def self.find_or_create(nick)
    like(nick) || Alice::Util::Mediator.exists?(nick) && create(primary_nick: nick.downcase)
  end

  def self.like(nick)
    where(primary_nick: nick.downcase).first || where(alt_nicks: nick.downcase).first
  end

  def self.random
    all.sample
  end

  def self.update_nick(old_nick, new_nick)
    user = like(old_nick) || like(new_nick)
    user ||= new(primary_nick: old_nick)
    user.alt_nicks << new_nick.downcase
    user.alt_nicks << old_nick.downcase
    user.alt_nicks = user.alt_nicks.uniq
    user.save
  end

  def self.set_twitter(nick, handle)
    return if handle.nil? || handle.empty?
    handle = "@#{handle}".gsub("@@", "@")
    find_or_create(nick).update_attributes(twitter_handle: handle)
  end

  def self.set_bio(nick, bio)
    user = find_or_create(nick)
    bio = bio.gsub(/^is/, '')
    bio = bio.gsub(/([a-zA-Z0-9\_]+) ^is/, '')
    user && user.update_attributes(bio: bio)
  end

  def self.get_bio(nick)
    user = find_or_create(nick)    
    return unless bio = user.bio
    formatted_bio
  end

  def self.set_factoid(nick, factoid)
    user = find_or_create(nick)
    user && user.factoids.create(text: factoid.gsub(/^I /,''))
  end

  def self.get_factoid(nick)
    return unless user = find_or_create(nick)  
    factoid = user.factoids.sample
    return factoid && factoid.formatted
  end

  def self.get_twitter(nick)
    user = find_or_create(nick)  
    twitter = user.twitter_handle
    return user && twitter
  end

  def has_nick?(nick)
    [self.primary_nick, self.alt_nicks].flatten.include?(nick.downcase)
  end

  def formatted_name
    self.proper_name
  end

  def update_thefts
    self.update_attributes(last_theft: DateTime.now)
  end

  def recently_stole?
    self.last_theft ||= DateTime.now - 1.day
    self.last_theft >= DateTime.now - 13.minutes
  end

  def fumble(what)
    treasure = Alice::Treasure.where(name: what.downcase).last
    treasure.user = [User.all.to_a - [self]].sample
    treasure.save
    treasure
  end

  def formatted_bio
    return unless self.bio.present?
    formatted = bio.gsub(/^is/, '')
    formatted = formatted.gsub(/^([a-zA-Z0-9\_]+) is/, '')
    "#{self.proper_name} is #{formatted}".gsub("  ", " ")
  end

  def try_stealing(what)
    treasure = Alice::Treasure.where(name: what.downcase).last
    if treasure && self.treasures.include?(treasure)
      item = fumble(what)
      return "laughs as #{self.formatted_name} fumbles the #{what} and it falls into #{treasure.owner}'s lap."
    end
    if recently_stole?
      return "thinks that #{self.formatted_name} shouldn't press their luck on the thievery front."
    end  
    unless treasure
      return "eyes #{m.user.nick} curiously."
    end  
    update_thefts
    if rand(10) == 1
      treasure.user = self && treasure.save
      return "watches in awe as #{m.formatted_name} steals the #{treasure.name} from #{treasure.owner}!"
    else
      return "sees #{formatted_name} try and fail to snatch the #{treasure.name} from #{treasure.owner}."
    end
  end

  def twitter_url
    return unless self.twitter_handle
    "https://twitter.com/#{self.twitter_handle.gsub("@", "").downcase}"
  end

  def inventory_of_beverages
    Alice::Beverage.inventory_from(self.proper_name, self.beverages)
  end

  def proper_name
    self.primary_nick.capitalize
  end

  def inventory_of_treasures
    Alice::Treasure.inventory_from(self.proper_name, self.treasures)
  end

end