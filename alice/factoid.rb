class Alice::Factoid

  include Mongoid::Document

  field :text
  field :keywords, type: Array, default: []

  index({ text: 1 }, { unique: true })
  index({ keywords: 1 }, { unique: false })

  validates_presence_of :text
  validates_uniqueness_of :text

  belongs_to :user

  before_create :extract_keywords

  def self.for(nick)
    User.with_nick_like(nick).try(:get_factoid)
  end

  def self.random
    all.sample
  end

  def self.about(subject)
    keywords = subject.split.map(&:downcase).uniq.map{|w| w.gsub!(/[^a-zA-Z0-9\_\-]/, '')}.compact
    keywords << keywords.map{|word| Lingua.stemmer(word.downcase)}
    keywords = keywords.flatten.uniq
    any_in(keywords: keywords).sample
  end

  def extract_keywords
    self.keywords = Alice::Parser::NgramFactory.filtered_grams_from(self.text).flatten.uniq
  end

  def formatted(with_prefix=true)
    fact = self.text
    fact = Alice::Util::Sanitizer.strip_pronouns(fact)
    fact = Alice::Util::Sanitizer.make_third_person(fact)
    fact = Alice::Util::Sanitizer.initial_downcase(fact)

    message = ""
    message << "#{Alice::Util::Randomizer.fact_prefix}" if with_prefix
    message << " #{self.user.try(:proper_name)} #{fact}."
    message
  end

end