class Alice::User

  include Mongoid::Document

  field :primary_nick
  field :alt_nicks, type: Array, default: []
  field :bio
  field :twitter_handle

  has_many :factoids

  def self.random
    all.sample
  end

  def self.like(nick)
    where(primary_nick: nick.downcase).first || where(alt_nicks: nick.downcase).first
  end

  def self.update_nick(old_nick, new_nick)
    user = like(m.user.nick)
    user ||= like(new_nick)
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
    user && user.update_attributes(bio: bio)
  end

  def self.get_bio(nick)
    user = find_or_create(nick)    
    return user && user.bio && user.bio.gsub(/^is/, '')
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

end