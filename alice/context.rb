require 'ruby-web-search'
class Context

  include Mongoid::Document

  field :topic
  field :keywords, type: Array
  field :corpus
  field :expires_at, type: DateTime
  field :is_current, type: Boolean
  field :spoken, type: Array, default: []
  field :created_at, type: DateTime

  AMBIGUOUS = "That may refer to several different things. Can you clarify?"
  MINIMUM_FACT_LENGTH = 15
  TTL = 5

  before_save :downcase_topic, :define_corpus, :extract_keywords
  before_create :set_expiry

  validates_uniqueness_of :topic, case_sensitive: false

  store_in collection: "alice_contexts"

  def self.with_keywords
    where(:keywords.not => { "$size" => 0 })
  end

  def self.current
    if context = where(is_current: true).desc(:expires_at).last
      ! context.expire && context
    end
  end

  def self.keywords_from(topic)
    topic.to_s.downcase.split - Grammar::LanguageHelper::PREDICATE_INDICATORS
  end

  def self.find_or_create(topic)
    from(topic) || create(topic: topic)
  end

  def self.with_topic_matching(topic)
    ngrams = Grammar::NgramFactory.new(topic).omnigrams
    ngrams = ngrams.map{|g| g.join(' ')}
    if exact_match = any_in(topic: ngrams).first
      return exact_match
    end
  end

  def self.with_keywords_matching(topic)
    topic_keywords = keywords_from(topic)
    any_in(keywords: topic_keywords).sort do |a,b|
      (a.keywords & topic_keywords).count <=> (b.keywords & topic_keywords).count
    end.last
  end

  def self.from(*topic)
    topic.join(' ') if topic.respond_to?(:join)
    with_topic_matching(topic) || with_keywords_matching(topic)
  end

  def ambiguous?
    self.corpus.map{|fact| fact.include?("may refer to") || fact.include?("disambiguation") }.any?
  end

  def current!
    update_attributes(is_current: true, expires_at: DateTime.now + TTL.minutes)
  end

  def expire
    expire! if (self.expires_at.nil? || self.expires_at < DateTime.now)
  end

  def describe
    return AMBIGUOUS if ambiguous?
    fact = facts.select{ |sentence| near_match(self.topic, sentence) }.first
    record_spoken(fact)
    fact
  end

  def define_corpus
    self.corpus ||= begin
      sanitized = fetch_content_from_sources
      sanitized = Util::Sanitizer.scrub_wiki_content(sanitized)
      sanitized = sanitized.reject{|s| s.include?("may refer to") || s.include?("disambiguation") }
      sanitized = sanitized.reject{|s| s.size < MINIMUM_FACT_LENGTH}
      sanitized
    rescue Exception => e
      Alice::Util::Logger.info "*** Unable to fetch corpus for \"#{self.topic}\": #{e}"
      Alice::Util::Logger.info e.backtrace
    ensure
      ""
    end
  end

  def declarative_fact(subtopic, spoken=true)
    return AMBIGUOUS if ambiguous?
    fact = relational_facts(subtopic).select do |sentence|
      has_info_verb = sentence =~ /\b#{Grammar::LanguageHelper::INFO_VERBS * '|\b'}/ix
      placement = position_of(subtopic.downcase, sentence.downcase)
      has_info_verb && placement && placement.to_i < 100
    end.sample
    record_spoken(fact) if spoken
    fact
  end

  def facts
    corpus.to_a.reject{|sentence| spoken.include? sentence}.sort do |a,b|
      is_was_sort_value(a) <=> is_was_sort_value(b)
    end
  end

  def has_spoken_about?(topic)
    self.spoken.to_s.downcase.include?(topic.downcase)
  end

  def inspect
    %{#<Context _id: #{self.id}", topic: "#{self.topic}", keywords: #{self.keywords.count}, is_current: #{is_current}, expires_at: #{self.expires_at}"}
  end

  def random_fact
    return AMBIGUOUS if ambiguous?
    facts.sample
  end

  def relational_fact(subtopic, spoken=true)
    return AMBIGUOUS if ambiguous?
    fact = relational_facts(subtopic).sample
    record_spoken(fact) if spoken
    fact
  end

  def targeted_fact(subtopic, spoken=true)
    return AMBIGUOUS if ambiguous?
    fact = targeted_fact_candidates(subtopic).sample
    record_spoken(fact) if spoken
    fact
  end

  private

  def downcase_topic
    self.topic.downcase!
  end

  def extract_keywords
    self.keywords = begin
      candidates = Grammar::LanguageHelper.probable_nouns_from(corpus.join(" "))
      candidates = candidates.inject(Hash.new(0)) {|h,i| h[i] += 1; h }
      candidates.select{|k,v| v > 1}.map(&:first)
    rescue
      []
    end.flatten
  end

  def is_was_sort_value(element)
    (position_of("is", element) || position_of("was", element) || 100) - 100
  end

  def expire!
    update_attributes(is_current: false, spoken: [])
  end

  def fetch_content_from_sources
    content = Parser::User.fetch(topic)
    content += Parser::Wikipedia.fetch(topic).to_s
    content +=  Parser::Google.fetch(topic)
  end

  def near_match(subject, sentence)
    (sentence.downcase.split & subject.split).size > 0
  end

  def position_of(word, sentence)
    sentence =~ /\b#{word}/i
  end

  def record_spoken(fact)
    return unless fact
    self.spoken << fact
    update_attribute(:spoken, self.spoken.uniq)
  end

  def relational_facts(subtopic)
    facts.select do |sentence|
      next unless sentence =~ /\b#{subtopic}/ix
      placement = position_of(subtopic.downcase, sentence.downcase)
      placement && placement.to_i < 100
    end
  end

  def set_expiry
    self.expires_at = DateTime.now + TTL.minutes
  end

  def targeted_fact_candidates(subtopic)
    candidates = facts.select{|fact| fact =~ /#{subtopic}/i} + facts.select{|sentence| sentence =~ /#{subtopic}/i}
    candidates = candidates.reject{|candidate| candidate.size < topic.size + 10}
    candidates
  end
end
