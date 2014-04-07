class Alice::User

  include Mongoid::Document

  field :primary_nick
  field :alt_nicks, type: Array, default: []
  field :bio
  field :twitter_handle
  field :last_theft, type: DateTime

  has_many :factoids
  has_many :treasures

  def self.random
    all.sample
  end

  def inventory
    treasure_names = ["empty pockets", "nothing", "no treasures", "nada"].sample unless self.treasures.count > 0
    treasure_names ||= self.treasures.map{|t| "the #{t.name}"}.to_sentence
    "#{self.primary_nick.capitalize}'s' worldy possessions include: #{treasure_names}."
  end

  def self.from(string)
    string.split(/[^a-zA-Z0-9\_]/).map{|name| Alice::User.like(name) }.compact || []
  end

  def self.like(nick)
    where(primary_nick: nick.downcase).first || where(alt_nicks: nick.downcase).first
  end

  def self.update_nick(old_nick, new_nick)
    user = like(old_nick) || like(new_nick)
    user ||= new(primary_nick: old_nick)
    user.alt_nicks << new_nick.downcase
    user.alt_nicks << old_nick.downcase
    user.alt_nicks = user.alt_nicks.uniq
    user.save
  end

  def self.find_or_create(nick)
    like(nick) || Alice.bot.exists?(nick) && create(primary_nick: nick.downcase)
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
    self.primary_nick.capitalize
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
    "#{self.primary_nick.capitalize} is #{formatted}".gsub("  ", " ")
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

end