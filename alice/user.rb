class Alice::User

  include Mongoid::Document

  field :primary_nick
  field :bio
  field :twitter_handle
  field :has_fruitcake
  
  has_many :factoids

  def self.find_or_create(nick)
    where(primary_nick: nick.downcase).first || create(primary_nick: nick.downcase)
  end

  def self.set_tiwtter(nick, bio)
    find_or_create(nick).update_attributes(bio: bio)
  end

  def self.set_bio(nick, bio)
    find_or_create(nick).update_attributes(bio: bio)
  end

  def self.get_bio(nick)
    user = find_or_create(nick)    
    return user && user.bio && user.bio.gsub(/^is/, '')
  end

  def self.set_factoid(nick, factoid)
    find_or_create(nick).factoids.create(text: factoid.gsub(/^I /,''))
  end

  def self.get_factoid(nick)
    user = find_or_create(nick)  
    factoid = user.factoids.sample
    return factoid && factoid.formatted
  end

  def formatted_name
    self.primary_nick.capitalize
  end

end