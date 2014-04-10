class Alice::User

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Scorable
  include Alice::Behavior::HasInventory
  include Alice::Behavior::Emotes
  include Alice::Behavior::Steals
  
  field :primary_nick
  field :alt_nicks, type: Array, default: []
  field :twitter_handle
  field :last_theft, type: DateTime
  field :last_award, type: DateTime
  field :last_game, type: DateTime
  field :is_bot, type: Boolean, default: false
  field :points, type: Integer, default: 0
  
  has_one  :bio
  has_many :factoids
  has_many :items
  has_many :beverages

  def self.online
    Alice::Util::Mediator.user_list.map{|user| like(user.nick)}.compact
  end

  def self.active_and_online
    active & online
  end

  def self.bot
    where(is_bot: true).last
  end

  def self.with_weapon
    Alice::Item.weapons.excludes(user_id: nil).map(&:user)
  end

  def self.active
    where(:updated_at.gte => DateTime.now - 10.minutes)
  end

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

  def creations
    Alice::Item.where(creator_id: self.id)
  end

  def can_brew?
    self.beverages.count < 4
  end

  def can_forge?
    self.items.count < 5 && self.creations.count < 6
  end

  def can_play_game?
    self.last_game ||= DateTime.now - 1.day
    self.last_game <= DateTime.now - 13.minutes
  end

  def description
    describe
  end

  def describe
    message = ""
    if self.bio.present?
      message << "#{proper_name} is #{self.bio.formatted}. " 
    else
      message << "It's #{proper_name}! "
    end
    message << "Find them on Twitter as #{self.twitter_handle}. " if self.twitter_handle.present?
    message << "They currently have #{self.points == 1 ? "1 point" : self.points.to_s << ' points'} "
    message << "#{self.inventory}"
  end

  def has_nick?(nick)
    [self.primary_nick, self.alt_nicks].flatten.include?(nick.downcase)
  end

  def is_present?
    true
  end

  def formatted_name
    self.proper_name
  end

  def formatted_bio
    return unless self.bio.present?
    formatted = bio.text.gsub(/^is/, '')
    formatted = formatted.gsub(/^([a-zA-Z0-9\_]+) is/, '')
    "#{self.proper_name} is #{formatted}".gsub("  ", " ")
  end
  
  def online?
    Alice::Util::Mediator.user_list.select{|m| Alice::User.like(channel_user) == self}.present?
  end

  def proper_name
    self.primary_nick.capitalize
  end

  def twitter_url
    return unless self.twitter_handle
    "https://twitter.com/#{self.twitter_handle.gsub("@", "").downcase}"
  end

end