class User

  include Mongoid::Document
  include Mongoid::Timestamps
  include Alice::Behavior::Searchable
  include Alice::Behavior::Scorable
  include Alice::Behavior::HasInventory
  include Alice::Behavior::Emotes
  include Alice::Behavior::Steals

  store_in collection: "alice_users"

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
  has_many :wands

  validates_presence_of :primary_nick
  validates_uniqueness_of :primary_nick

  def self.search_attr
    :primary_nick
  end

  def self.award_points_to_active(points=0)
    active_and_online.each{|actor| actor.score_points(points) }
  end

  def self.bot_name
    bot.primary_nick
  end

  def self.default_user
    online.last
  end

  def self.online
    list = Alice::Util::Mediator.user_nicks
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
    (User.with_weapon & User.active_and_online)
  end

  def self.find_or_create(nick)
    by_nick(nick) || Alice::Util::Mediator.exists?(nick) && create(primary_nick: nick.downcase, alt_nicks: ["#{nick.downcase}_"])
  end

  def self.random
    all.sample
  end

  def self.by_nick(nick)
    scrubbed_nick = nick.to_s.downcase
    found = where(primary_nick: nick.downcase).first || where(primary_nick: scrubbed_nick).first
    found ||= where(alt_nicks: nick.downcase).first || where(alt_nicks: scrubbed_nick).first
    found
  end

  def self.with_key
    Item.keys.excludes(user_id: nil).map(&:user)
  end

  def self.with_weapon
    Item.weapons.excludes(user_id: nil).map(&:user)
  end

  def accepts_gifts?
    ! self.is_bot? && is_online?
  end

  def creations
    Item.where(creator_id: self.id)
  end

  def can_brew?
    self.beverages.count < 4
  end

  def can_forge?
    self.items.count < 10
  end

  def last_seen

    secs  = (Time.now - self.updated_at).to_i
    minutes = secs / 60
    hours = minutes / 60
    days  = hours / 24

    minutes_string = minutes % 60 == 1 ? "minute" : "minutes"
    hours_string = hours == 1 ? "hour" : "hours"
    days_string = days == 1 ? "day" : "days"

    if days < 2
      string = "about #{hours} #{hours_string}"
      string << " and #{minutes % 60} #{minutes_string}" if (minutes % 60) < 60
      string << " ago"
    else
      string = "about #{days} #{days_string}"
      string << " and #{hours} #{hours_string}" if hours < 24
      string << " ago"
    end

  end

  def play!(points)
    self.score_point(points)
    self.update_attribute(:last_game, DateTime.now)
  end

  def can_play_game?
    self.last_game ||= DateTime.now - 1.day
    self.last_game <= DateTime.now - 13.minutes
  end

  def current_nick
    (Alice::Util::Mediator.user_nicks & self.nicks).first || self.primary_nick
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

  def describe
    message = self.bio && self.bio.formatted || ". "
    message << "They're on Twitter as #{self.twitter_handle}. " if self.twitter_handle.present?
    message << "#{self.inventory} "
    message << "#{check_score} "
    message << "#{proper_name} is currently feeling a little #{self.filters.map(&:to_s).to_sentence}. " if self.filters.present?
    message
  end

  def has_nick?(nick)
    nicks.include?(nick.downcase)
  end

  def is_online?
    (Mediator.user_nicks & self.nicks).any?
  end

  def is_op?
    (Mediator.op_nicks & self.nicks).any?
  end

  def formatted_bio
    bio && bio.formatted || nil
  end

  def filter_applied_date
    self.filter_applied || DateTime.now - 1.day
  end

  def nicks
    (self.alt_nicks | [self.primary_nick]).map(&:downcase)
  end

  def proper_name
    self.primary_nick.capitalize
  end

  def random_factoid
    self.factoids.sample
  end

  def remove_filter?
    filter_applied_date <= DateTime.now - 13.minutes
  end

  def set_factoid(text)
    self.factoids.create(text: text)
  end

  # TODO Extract twitter info into object
  def set_twitter_handle(handle)
    handle = handle.split[0].gsub("@", "")
    self.update_attribute(:twitter_handle, handle)
  end

  def formatted_twitter_handle
    return unless self.twitter_handle
    "#{proper_name} is on Twitter as @#{self.twitter_handle.gsub('@','')}. Find them at https://twitter.com/#{self.twitter_handle.gsub("@", "").downcase}"
  end

  def twitter_url
    return unless self.twitter_handle
    "https://twitter.com/#{self.twitter_handle.gsub("@", "").downcase}"
  end

  def update_bio(content)
    bio = self.bio || Bio.new(user: self)
    bio.text = content
    bio.save
  end

  def update_nick(new_nick)
    return false if has_nick?(new_nick)
    update_attribute(:alt_nicks, [self.alt_nicks, new_nick.downcase].flatten.uniq)
  end

  alias_method :description, :describe
  alias_method :formatted_name, :proper_name

end
