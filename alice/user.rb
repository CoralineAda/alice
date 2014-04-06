class Alice::User

  include Mongoid::Document

  field :primary_nick
  field :bio

  has_many :factoids

  def self.find_or_create(nick)
    user = where(primary_nick: nick.downcase).first || create(primary_nick: nick.downcase)
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
    factoid = user && user.factoids.sample
    return factoid && user.formatted_factoid(factoid)
  end

  def formatted_name
    self.primary_nick.capitalize
  end

  def formatted_factoid(factoid)
    prefix = [
      "",
      "True story:",
      "I seem to recall that",
      "Rumor has it that",
      "Some believe that",
      "Some say",
      "It's been said that",
      "Legend says",
      "According to my notes,",
      "If the rumors are to be believed,",
      "Word on the street is that"
    ].sample
    "#{prefix} #{formatted_name} #{factoid.text}".gsub(/[\.\!\?]$/, '.')
  end

  def self.factiod_prefix
  end

end