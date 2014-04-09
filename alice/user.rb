class Alice::User

  include Mongoid::Document
  include Alice::Behavior::Searchable
  include Alice::Behavior::Scorable
  
  field :primary_nick
  field :alt_nicks, type: Array, default: []
  field :twitter_handle
  field :last_theft, type: DateTime
  field :is_bot, type: Boolean, default: false
  field :points, type: Integer, default: 0

  has_one  :bio
  has_many :factoids
  has_many :items
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

  def has_nick?(nick)
    [self.primary_nick, self.alt_nicks].flatten.include?(nick.downcase)
  end

  def formatted_name
    self.proper_name
  end

  def formatted_bio
    return unless self.bio.present?
    formatted = bio.gsub(/^is/, '')
    formatted = formatted.gsub(/^([a-zA-Z0-9\_]+) is/, '')
    "#{self.proper_name} is #{formatted}".gsub("  ", " ")
  end
  
  def inventory_of_beverages
    Alice::Beverage.inventory_from(self.proper_name, self.beverages)
  end

  def inventory_of_items
    Alice::Item.inventory_from(self.proper_name, self.items)
  end

  def proper_name
    self.primary_nick.capitalize
  end

  def twitter_url
    return unless self.twitter_handle
    "https://twitter.com/#{self.twitter_handle.gsub("@", "").downcase}"
  end

end