class User

  include Mongoid::Document
  include Mongoid::Timestamps
  include Behavior::Searchable
  include Behavior::Scorable
  include Behavior::HasInventory
  include Behavior::Emotes
  include Behavior::Steals

  store_in collection: "alice_users"

  field :primary_nick
  field :alt_nicks,           type: Array, default: []
  field :twitter_handle
  field :last_theft,          type: DateTime
  field :last_award,          type: DateTime
  field :last_game,           type: DateTime
  field :last_active,         type: DateTime
  field :is_bot,              type: Boolean
  field :points,              type: Integer, default: 0
  field :filters,             type: Array, default: []
  field :pronoun_primary,     default: "they"
  field :pronoun_objective,   default: "them"
  field :pronoun_possessive,  default: "their"
  field :pronoun_predicate,   default: "theirs"
  field :filter_applied,      type: DateTime

  index({ primary_nick: 1 },  { unique: true })
  index({ alt_nicks: 1 },     { unique: true })

  has_one  :bio
  has_many :factoids
  has_many :items
  has_many :beverages
  has_many :wands

  validates_presence_of :primary_nick
  validates_uniqueness_of :primary_nick

  PROPERTIES = [
    :can_brew?,
    :can_forge?,
    :last_seen,
    :can_play_games?,
    :current_nick,
    :dazed?,
    :disoriented?,
    :drunk?,
    :is_online?,
    :is_op?,
    :bio,
    :proper_name,
    :twitter_handle,
    :check_score,
    :check_points,
    :formatted_twitter_handle
  ]

  INACTIVITY_THRESHOLD = 13

  def self.from(string)
    return unless string.present?
    names = Grammar::NgramFactory.new(string).omnigrams
    names = names.map{|g| g.join ' '} << string
    names = names.uniq - Grammar::LanguageHelper::IDENTIFIERS
    objects = names.map do |name|
      name = (name.split(/\s+/) - Grammar::LanguageHelper::IDENTIFIERS).compact.join(' ')
      if name.present? && found = like(name) || found = User.where(primary_nick: name).first || found = User.any_in(alt_nicks: name).first
        SearchResult.new(term: name, result: found)
      end
    end.compact
    objects = objects.select{|obj| obj.result.present?}.uniq || []
    objects.sort{|b,a| b.term.length <=> a.term.length}.map(&:result).last
  end

  def self.like(name)
    name = name.respond_to?(:join) && name.join(' ') || name
    match = where(primary_nick: /^#{Regexp.escape(name)}$/i).first
    match ||= where(alt_nicks: name).first
    match ||= where(primary_nick: /\b#{Regexp.escape(name)}\b/i).first
    match
  end

  def self.search_attr
    :alt_nicks
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

  def self.active_and_online
    active
  end

  def self.bot
    where(is_bot: true).last
  end

  def self.active
    where(:updated_at.gte => DateTime.now - INACTIVITY_THRESHOLD.minutes)
  end

  def self.fighting
    (User.with_weapon & User.active_and_online)
  end

  def self.find_or_create(nick)
    by_nick(nick) || Pipeline::Mediator.exists?(nick) && create(primary_nick: nick.downcase, alt_nicks: ["#{nick.downcase}_"])
  end

  def self.non_bot
    where(is_bot: false)
  end

  def self.random
    all.sample || User.new(primary_nick: "Eleanor Nobody")
  end

  def self.by_nick(nick)
    scrubbed_nick = nick.to_s.downcase
    found = where(primary_nick: scrubbed_nick).first || where(primary_nick: scrubbed_nick).first
    found ||= where(alt_nicks: scrubbed_nick).first || where(alt_nicks: scrubbed_nick).first
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

  def awake?
    self.updated_at >= DateTime.now - INACTIVITY_THRESHOLD.minutes
  end

  def active!
    update_attribute(:last_active, DateTime.now)
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

  def current_nick
    self.primary_nick
  end

  def last_seen

    secs  = (Time.now - self.updated_at).to_i
    minutes = secs / 60
    hours = minutes / 60
    days  = hours / 24

    minutes_string = minutes % 60 == 1 ? "minute" : "minutes"
    hours_string = hours == 1 ? "hour" : "hours"
    days_string = days == 1 ? "day" : "days"

    if hours < 1 && minutes < 10
      string = "just now"
    elsif hours < 1 && minutes < 60
      string = "just #{minutes_string} ago"
    elsif days < 1
      string = "about #{hours} #{hours_string}"
      string << " and #{minutes % 60} #{minutes_string}" if (minutes % 60) < 60
      string << " ago"
    else
      string = "about #{days} #{days_string} ago"
    end

  end

  def play!(points)
    self.score_point(points)
    update_attribute(:last_game, DateTime.now)
  end

  def can_play_games?
    self.last_game ||= DateTime.now - 1.day
    self.last_game <= DateTime.now - 13.minutes
  end

  def dazed?
    self.filters.map(&:to_s).include?('dazed')
  end

  def disoriented?
    self.filters.map(&:to_s).include?('disoriented')
  end

  def drunk?
    self.filters.map(&:to_s).include?('drunk')
  end

  def describe
    message = ""
    message << self.bio.formatted if self.bio.present?
    if self.created_at
      message << "#{self.pronoun_primary} first joined us on #{self.created_at.strftime("%B %-d, %Y")}. "
    end
    message << "Find #{self.pronoun_objective} on Twitter as #{self.twitter_handle}. " if self.twitter_handle.present?
    message << pronouns
    message << "#{check_score}. "
    message << "#{self.inventory} "
    message << "#{proper_name} is currently feeling a little #{self.filters.map(&:to_s).to_sentence}. " if self.filters.present?
    message
  end

  def has_nick?(nick)
    nicks.include?(nick.downcase)
  end

  def is_online?
    true
  end

  def is_op?
    (Pipeline::Mediator.op_nicks & self.nicks).any?
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

  def remove_expired_filters
    if filter_applied_date <= DateTime.now - 90.minutes
      update_attribute(:filters, [])
    else
      false
    end
  end

  def set_factoid(text)
    self.factoids.create(text: text)
  end

  def set_twitter_handle(handle)
    handle = handle.split[0].gsub("@", "")
    update_attribute(:twitter_handle, handle)
  end

  def set_pronouns(pronouns)
    pronouns = pronouns.split("/")
    update_attributes(
      pronoun_primary: pronouns[0] || "they",
      pronoun_objective: pronouns[1] || "them",
      pronoun_possessive: pronouns[2] || "their",
      pronoun_predicate: pronouns[3] || "theirs"
    )
  end

  def pronouns
    "Preferred pronouns: #{self.pronoun_primary}/#{pronoun_objective}/#{pronoun_possessive}/#{pronoun_predicate}. "
  end

  def pronoun_contraction
    return "she's" if pronoun_objective == "she"
    return "he's" if pronoun_objective == "he"
    "they're"
  end

  def formatted_twitter_handle
    return unless self.twitter_handle
    "#{proper_name} is on Twitter as @#{self.twitter_handle.gsub('@','')}. Find #{self.pronoun_objective} at #{twitter_url}"
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

  def info_factoids
    factoids.map(&:text)
  end

  def formatted_last_seen
    "Last seen #{last_seen}."
  end

  alias_method :description, :describe
  alias_method :formatted_name, :proper_name
  alias_method :info_formatted_bio, :formatted_bio
  alias_method :info_formatted_last_seen, :formatted_last_seen

# Informational methods
  PROPERTIES.each do |property|
    alias_method property.to_s.sub(/^/, 'info_').to_sym, property
  end

end
