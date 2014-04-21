class Alice::User

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Scorable
  include Alice::Behavior::HasInventory
  include Alice::Behavior::Emotes
  include Alice::Behavior::Steals

  field :primary_nick
  field :alt_nicks,         type: Array, default: []
  field :twitter_handle
  field :last_theft,        type: DateTime
  field :last_award,        type: DateTime
  field :last_game,         type: DateTime
  field :is_bot,            type: Boolean
  field :points,            type: Integer, default: 0
  field :filters,           type: Array, default: []
  field :filter_applied, type: DateTime

  index({ primary_nick: 1 },  { unique: true })
  index({ alt_nicks: 1 },     { unique: true })

  has_one  :bio
  has_many :factoids
  has_many :items
  has_many :beverages

  validates_presence_of :primary_nick
  validates_uniqueness_of :primary_nick

  def self.by_nick(nick)
    where(primary_nick: nick).last
  end

  def self.online
    list = Alice::Util::Mediator.user_list.map(&:nick).map(&:downcase)
    any_in(primary_nick: list) | any_in(alt_nicks: list)
  end

  def self.active_and_online
    active.online
  end

  def self.bot
    where(is_bot: true).last
  end

  def self.active
    where(:updated_at.gte => DateTime.now - 10.minutes)
  end

  def self.fighting
    (Alice::User.with_weapon & Alice::User.active_and_online)
  end

  def self.find_or_create(nick)
    with_nick_like(nick) || Alice::Util::Mediator.exists?(nick) && create(primary_nick: nick.downcase, alt_nicks: ["#{nick.downcase}_"])
  end

  def self.like(arg)
    with_nick_like(arg)
  end

  def self.random
    all.sample
  end

  def self.with_nick_like(nick)
    scrubbed_nick = nick.to_s.gsub('_','').downcase
    found = where(primary_nick: nick.downcase).first || where(primary_nick: scrubbed_nick).first
    found ||= where(alt_nicks: nick.downcase).first || where(alt_nicks: scrubbed_nick).first
    found
  end

  def self.with_key
    Alice::Item.keys.excludes(user_id: nil).map(&:user)
  end

  def self.with_weapon
    Alice::Item.weapons.excludes(user_id: nil).map(&:user)
  end

  def self.update_nick(old_nick, new_nick)
    user = with_nick_like(old_nick) || with_nick_like(new_nick)
    user ||= new(primary_nick: old_nick)
    user.alt_nicks << new_nick.downcase
    user.alt_nicks << old_nick.downcase
    user.alt_nicks = user.alt_nicks.uniq
    user.save
  end

  def accepts_gifts?
    ! self.is_bot?
  end

  def apply_filters(text)
    if remove_filter?
      self.update_attribute(:filters, [])
      return text
    else
      self.filters.inject([]) do |processed, filter|
        processed[0] = eval("Alice::Filters::#{filter.to_s.classify}").new.process(processed.first || text)
        processed
      end.first || text
    end
  end

  def creations
    Alice::Item.where(creator_id: self.id)
  end

  def can_brew?
    self.beverages.count < 4
  end

  def can_forge?
    self.items.count < 4
  end

  def can_play_game?
    self.last_game ||= DateTime.now - 1.day
    self.last_game <= DateTime.now - 13.minutes
  end

  def dazed?
    self.filters.include?(:dazed)
  end

  def disoriented?
    self.filters.include?(:disoriented)
  end

  def drunk?
    self.filters.include?(:drunk)
  end

  def description
    describe
  end

  def describe
    message = ""
    if self.bio.present?
      message << "#{self.bio.formatted}. "
    else
      message << "It's #{proper_name}! "
    end
    message << "Find them on Twitter as #{self.twitter_handle}. " if self.twitter_handle.present?
    message << "#{self.inventory} "
    message << "#{check_score} "
    message << "#{proper_name} is currently feeling a little #{self.filters.map(&:to_s).to_sentence}. " if self.filters.present?
    message
  end

  def remove_filter?
    self.filter_applied ||= DateTime.now - 1.day
    self.filter_applied <= DateTime.now - 13.minutes
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
    Alice::Util::Mediator.user_list.select{|m| Alice::User.with_nick_like(channel_user) == self}.present?
  end

  def proper_name
    self.primary_nick.capitalize
  end

  def twitter_url
    return unless self.twitter_handle
    "https://twitter.com/#{self.twitter_handle.gsub("@", "").downcase}"
  end

end