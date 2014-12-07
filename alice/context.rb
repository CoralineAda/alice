class Alice::Context

  include Mongoid::Document

  field :topic
  field :keywords, type: Array, default: []
  field :corpus
  field :expires_at, type: DateTime
  field :is_current, type: Boolean
  field :spoken, type: Array, default: []

  TTL = 5
  PREDICATE_INDICATORS = %w{to from with on in about the and or near from by}

  before_save :downcase_topic, :define_corpus, :extract_keywords
  before_create :set_expiry
  validates_uniqueness_of :topic

  def self.with_keywords
    not_in(keywords: [])
  end

  def self.current
    if context = where(is_current: true).desc(:expires_at).first
      ! context.expire && context
    end
  end

  def self.find_or_create(topic)
    from(topic) || create(topic: topic)
  end

  def self.from(topic)
    topic_keywords = topic.to_a.compact.map(&:split).flatten.map(&:downcase)
    topic_keywords = topic_keywords - Alice::Parser::LanguageHelper::PREDICATE_INDICATORS
    if exact_match = any_in(topic: topic_keywords).first
      return exact_match
    end
    any_in(keywords: topic_keywords).sort do |a,b|
      (a.keywords & topic_keywords).count <=> (b.keywords & topic_keywords).count
    end.last
  end

  def self.about(topic, subtopic=nil)
    return unless topic = from(topic)
    if subtopic
      topic.relational_fact(subtopic)
    else
      topic.targeted_fact(topic)
    end
  end

  def self.any_from(*topic)
    topic_array = topic.to_a.compact.map(&:split).flatten.map(&:downcase)
    from(topic) || about(topic_array[0..1])
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
    candidates = facts.select{ |sentence| near_match(self.topic, sentence) }
    fact = candidates.compact.sort do |a,b|
      position_of('is', a).to_i || position_of('was', a).to_i <=> position_of('is', b).to_i || position_of('was', b).to_i
    end.first
    record_spoken(fact)
    fact
  end

  def near_match(subject, sentence)
    (sentence.downcase.split & subject.split).size > 0
  end

  def define_corpus
    self.corpus ||= begin
      sanitized = ::Sanitize.fragment(Wikipedia.find(self.topic).sanitized_content)
      sanitized = sanitized.split(/[\.\:\[\]\n\*\=] /)
      sanitized = sanitized.reject{|w| w == " "}
      sanitized = sanitized.reject(&:empty?)
      sanitized = sanitized.map(&:strip)
      sanitized
    rescue Exception => e
      Alice::Util::Logger.info "*** Unable to fetch corpus for \"#{self.topic}\": #{e}"
    end
  end

  def downcase_topic
    self.topic.downcase!
  end

  def extract_keywords
    candidates = probable_nouns.inject(Hash.new(0)) {|h,i| h[i] += 1; h }
    self.keywords = candidates.select{|k,v| v > 1}.map(&:first)
  end

  def has_spoken_about?(topic)
    self.spoken.to_s.downcase.include?(topic.downcase)
  end

  def probable_nouns
    re = Regexp.union(PREDICATE_INDICATORS.map{|w| /\b#{Regexp.escape(w)}\b/i})
    candidates = self.corpus.split(re).flatten
    candidates = candidates.map{|candidate| candidate.gsub(/[^a-zA-Z]/x, " ")}.compact
    candidates = candidates.map(&:split).map(&:last).flatten.compact.map(&:downcase)
  end

  def random_fact
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

  def declarative_fact(subtopic)
    fact = relational_facts(subtopic).select do |sentence|
      has_info_verb = sentence =~ /\b#{Alice::Parser::LanguageHelper::INFO_VERBS * '|\b'}/ix
      placement = position_of(subtopic.downcase, sentence.downcase)
      has_info_verb && placement && placement.to_i < 100
    end.sample
    record_spoken(fact)
    fact
  end

  def targeted_fact(subtopic)
    fact = targeted_fact_candidates(subtopic).sample
    record_spoken(fact)
    fact
  end

  def relational_fact(subtopic)
    fact = relational_facts(subtopic).sample
    record_spoken(fact)
    fact
  end

  def facts
    corpus.reject{|sentence| spoken.include? sentence}.sort do |a,b|
      (a =~ /is|was/i).to_i <=> (b =~ /is|was/i).to_i
    end.reverse
  end

  def record_spoken(fact)
    return unless fact
    self.spoken << fact
    update_attribute(:spoken, self.spoken.uniq)
  end

  def inspect
    %{#<Alice::Context _id: #{self.id}", topic: "#{self.topic}", keywords: #{self.keywords.count}, is_current: #{is_current}, expires_at: #{self.expires_at}"}
  end

  private

  def position_of(word, sentence)
    sentence =~ /\b#{word}/i
  end

end
