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

  def self.ranked_matches(matches, terms=[])
    matches.map do |match|
      RankedMatch.new(term: match, rank: (match.keywords & terms).count)
    end
  end

  def self.best_match(matches, terms=[])
    ranked = ranked_matches(matches, terms)
    best_score = ranked.map(&:rank).max
    ids = ranked.select{|m| m.rank == best_score}.map(&:term).map(&:id)
    any_in(id: ids).sample
  end

  def self.about(subject)
    return unless subject
    subject = (subject.downcase.split - Alice::Parser::LanguageHelper::PREPOSITIONS).join(" ")
    user = User.from(subject)
    if user && user.factoids.present?
      return user.factoids && user.factoids.sample
    end
    keywords = subject.downcase.split.select{|w| w.size > 3}.map{|w| w.gsub(/[^a-zA-Z0-9\_\-]/, '')}
    keywords << keywords.map{|word| Lingua.stemmer(word.downcase)}
    keywords = keywords.flatten.uniq
    factoid = best_match(any_in(keywords: keywords), keywords)
    factoid
  end

  def extract_keywords
    terms = Alice::Parser::NgramFactory.filtered_grams_from(self.text.downcase).flatten.uniq
    terms = terms - Alice::Parser::LanguageHelper::ARTICLES
    terms << terms.map{|word| Lingua.stemmer(word.downcase)}
    self.keywords = terms.flatten
  end

  def formatted(with_prefix=false)
    return Constants::FAX_NOT_FOUND unless self.text.present?
    fact = self.text
    # fact = Alice::Util::Sanitizer.strip_pronouns(fact)
    # fact = Alice::Util::Sanitizer.make_third_person(fact)
    # fact = Alice::Util::Sanitizer.initial_downcase(fact)
    if self.user.present?
      message = "#{self.user.primary_nick} once said \"#{fact}\""
    else
      message = "#{Alice::Util::Randomizer.fact_prefix}" if with_prefix
      message.to_s << " #{fact}"
    end
    message
  end

  class RankedMatch
    attr_accessor :term, :rank
    def initialize(args={}); self.term = args[:term]; self.rank = args[:rank]; end
  end

end
