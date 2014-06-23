class Factoid

  include Mongoid::Document
  include Behavior::Samples

  store_in collection: "alice_factoids"

  field :text
  field :keywords, type: Array, default: []

  index({ text: 1 }, { unique: true })
  index({ keywords: 1 }, { unique: false })

  validates_presence_of :text
  validates_uniqueness_of :text

  belongs_to :user

  before_create :extract_keywords

  def self.about(subject)
    if user = User.from(subject)
      return user.factoids && user.factoids.sample || Factoid.new
    end
    keywords = subject.downcase.split.map{|w| w.gsub(/[^a-zA-Z0-9\_\-]/, '')}
    keywords << keywords.map{|word| Lingua.stemmer(word.downcase)}
    keywords = keywords.flatten.uniq
    factoid = any_in(keywords: keywords).sample
    factoid || Factoid.new
  end

  def extract_keywords
    self.keywords = Alice::Parser::NgramFactory.filtered_grams_from(self.text).flatten.uniq
  end

  def formatted(with_prefix=false)
    return Constants::FAX_NOT_FOUND unless self.text.present?
    fact = self.text
    fact = Alice::Util::Sanitizer.strip_pronouns(fact)
    fact = Alice::Util::Sanitizer.make_third_person(fact)
    fact = Alice::Util::Sanitizer.initial_downcase(fact)

    message = ""
    message << "#{Alice::Util::Randomizer.fact_prefix}" if with_prefix
    message << " #{self.user.try(:proper_name)} #{fact}"
    message
  end

end