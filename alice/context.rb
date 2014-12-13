class Context

  include Mongoid::Document

  field :topic
  field :keywords, type: Array
  field :corpus
  field :expires_at, type: DateTime
  field :is_current, type: Boolean
  field :spoken, type: Array, default: []

  TTL = 5
  AMBIGUOUS = "That may refer to several different things. Can you clarify?"
  MINIMUM_FACT_LENGTH = 30

  before_save :downcase_topic, :define_corpus, :extract_keywords
  before_create :set_expiry
  validates_uniqueness_of :topic
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
    topic.to_s.downcase.split - Parser::LanguageHelper::PREDICATE_INDICATORS
  end

  def self.find_or_create(topic)
    from(topic) || create(topic: topic)
  end

  # FIXME use ngrams here
  def self.with_topic_matching(topic)
    if exact_match = any_in(topic: [topic.downcase, keywords_from(topic).join(" ")]).first
      return exact_match
    end
  end

  # FIXME use ngrams here
  def self.with_keywords_matching(topic)
    topic_keywords = keywords_from(topic)
    any_in(keywords: topic_keywords).sort do |a,b|
      (a.keywords & topic_keywords).count <=> (b.keywords & topic_keywords).count
    end.last
  end

  def self.from(topic)
    with_topic_matching(topic) || with_keywords_matching(topic)
  end

  def ambiguous?
    self.corpus.map{|fact| fact.include?("may refer to") || fact.include?("disambiguation") }.any?
  end

  def current!
    update_attributes(is_current: true, expires_at: DateTime.now + TTL.minutes)
  end

  def set_expiry
    self.expires_at = DateTime.now + TTL.minutes
  end

  def expire
    expire! if (self.expires_at.nil? || self.expires_at < DateTime.now)
  end

  def expire!
    update_attributes(is_current: false, spoken: [])
  end

  def describe
    return AMBIGUOUS if ambiguous?
    fact = facts.select{ |sentence| near_match(self.topic, sentence) }.first
    record_spoken(fact)
    fact
  end

  def near_match(subject, sentence)
    (sentence.downcase.split & subject.split).size > 0
  end

  def define_corpus
    self.corpus ||= begin
      sanitized = fetch_content_from_sources(self.topic)
      sanitized = Util::Sanitizer.scrub_wiki_content(sanitized)
      sanitized = sanitized.reject{|s| s.include?("may refer to") || s.include?("disambiguation") }
      sanitized = sanitized.reject{|s| s.size < MINIMUM_FACT_LENGTH}
      sanitized
    rescue Exception => e
      Alice::Util::Logger.info "*** Unable to fetch corpus for \"#{self.topic}\": #{e}"
    end
  end

  def downcase_topic
    self.topic.downcase!
  end

  def extract_keywords
    self.keywords = begin
      candidates = Parser::LanguageHelper.probable_nouns_from(corpus.join(" "))
      candidates = candidates.inject(Hash.new(0)) {|h,i| h[i] += 1; h }
      candidates.select{|k,v| v > 1}.map(&:first)
    end.flatten
  end

  def has_spoken_about?(topic)
    self.spoken.to_s.downcase.include?(topic.downcase)
  end

  def random_fact
    return AMBIGUOUS if ambiguous?
    facts.sample
  end

  def relational_facts(subtopic)
    facts.select do |sentence|
      next unless sentence =~ /\b#{subtopic}/ix
      placement = position_of(subtopic.downcase, sentence.downcase)
      placement && placement.to_i < 100
    end
  end

  def targeted_fact_candidates(subtopic)
    candidates = facts.select{|fact| fact =~ /#{subtopic}/i} + facts.select{|sentence| sentence =~ /#{subtopic}/i}
    candidates = candidates.reject{|candidate| candidate.size < topic.size + 10}
    candidates
  end

  def declarative_fact(subtopic, spoken=true)
    return AMBIGUOUS if ambiguous?
    fact = relational_facts(subtopic).select do |sentence|
      has_info_verb = sentence =~ /\b#{Parser::LanguageHelper::INFO_VERBS * '|\b'}/ix
      placement = position_of(subtopic.downcase, sentence.downcase)
      has_info_verb && placement && placement.to_i < 100
    end.sample
    record_spoken(fact) if spoken
    fact
  end

  def targeted_fact(subtopic, spoken=true)
    return AMBIGUOUS if ambiguous?
    fact = targeted_fact_candidates(subtopic).sample
    record_spoken(fact) if spoken
    fact
  end

  def relational_fact(subtopic, spoken=true)
    return AMBIGUOUS if ambiguous?
    fact = relational_facts(subtopic).sample
    record_spoken(fact) if spoken
    fact
  end

  def facts
    return [] unless corpus
    candidates = corpus.reject{|sentence| spoken.include? sentence}
    candidates = candidates.reject{|sentence| sentence.include? "http"}
    candidates.to_a.sort do |a,b|
      (position_of("is", a) || position_of("was", a) || 100) - 100 <=> (position_of("is", b) || position_of("was", b) || 100) - 100
    end
  end

  def record_spoken(fact)
    return unless fact
    self.spoken << fact
    update_attribute(:spoken, self.spoken.uniq)
  end

  def inspect
    %{#<Context _id: #{self.id}", topic: "#{self.topic}", keywords: #{self.keywords.count}, is_current: #{is_current}, expires_at: #{self.expires_at}"}
  end

  private

  def position_of(word, sentence)
    sentence =~ /\b#{word}/i
  end

  def fetch_content_from_sources
    Wikipedia.find(self.topic).sanitized_content
  end

end
