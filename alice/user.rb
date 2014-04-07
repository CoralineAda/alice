class Alice::User

  include Mongoid::Document

  field :primary_nick
  field :alt_nicks, type: Array
  field :bio
  field :twitter_handle

  has_many :factoids

  def self.find_or_create(nick)
    where(primary_nick: nick.downcase).first || Alice.bot.exists?(nick) && create(primary_nick: nick.downcase)
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
    user = find_or_create(nick)  
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