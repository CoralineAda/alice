class Bio

  include Mongoid::Document

  store_in collection: :alice_bios

  field :text
  field :keywords, type: Array, default: []

  index({ text: 1 }, { unique: false })
  index({ keywords: 1 }, { unique: false })

  belongs_to :user

  validates_presence_of :text

  before_create :extract_keywords

  def self.for(name)
    user = User.from(name)
    user && user.bio || Bio.new
  end

  def self.random
    all.sample
  end

  # TODO extract into module. Repeated in bio, factoid, OH
  def extract_keywords
    self.keywords = Alice::Parser::NgramFactory.filtered_grams_from(self.text).flatten.uniq
  end

  def formatted
    return Constants::WHO_DAT unless self.user
    return "It's #{self.user.proper_name}! " unless self.user.present?
    formatted_text = self.text.gsub(/^is /, ' ')
    formatted_text = "#{self.user.proper_name} is #{formatted_text}"
    formatted_text = formatted_text.gsub(/is (was|has|had|does|doesn.t) /, '\1 ')
    formatted_text = formatted_text.gsub(/[ ]+/, " ")
  end

end