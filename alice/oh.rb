class OH

  include Mongoid::Document
  include Behavior::Samples

  store_in collection: :alice_oh

  field :text
  field :keywords, type: Array, default: []

  index({ text: 1 }, { unique: true })
  index({ keywords: 1 }, { unique: false })

  validates_presence_of :text
  validates_uniqueness_of :text

  before_create :extract_keywords

  def self.from(text)
    create(text: text)
  end

  # TODO extract into module. Repeated in bio, factoid, OH
  def extract_keywords
    self.keywords = Parser::NgramFactory.filtered_grams_from(self.text).flatten.uniq
  end

end
