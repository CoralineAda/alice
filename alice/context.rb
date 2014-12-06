class Alice::Context

  include Mongoid::Document

  field :topic
  field :keywords, type: Array, default: []
  field :corpus
  field :expires_at, type: DateTime
  field :is_current, type: Boolean

  TTL = 5
  PREDICATE_INDICATORS = %w{to from with on in about the and or near from by}

  before_save :downcase_topic, :define_corpus, :extract_keywords
  before_create :set_expiry

  def self.current
    if context = where(is_current: true).desc(:expires_at).first
      ! context.expire && context
    end
  end

  def self.find_or_create(topic)
    from(topic) || create(topic: topic)
  end

  def self.from(topic)
    topic_keywords = topic.to_a.map(&:split).flatten - Alice::Parser::LanguageHelper::PREDICATE_INDICATORS
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
    topic_array = topic.to_a.map(&:split).flatten
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
    update_attribute(:is_current, false)
  end

  def describe
    corpus.select do |sentence|
      topic_placement = sentence =~ /#{topic}/i
      (
        topic_placement &&
        topic_placement.to_i < 50 &&
        (sentence.include?("is a") || sentence.include?("was"))
      )
    end.sample || ""
  end

  def define_corpus
    self.corpus = begin
      sanitized = ::Sanitize.fragment(Wikipedia.find(self.topic).sanitized_content)
      sanitized = sanitized.split(/[\.\:\[\]\n\*\=]/)
      sanitized = sanitized.reject{|w| w == " "}
      sanitized = sanitized.reject(&:empty?)
      sanitized = sanitized.map(&:strip)
      sanitized
    end
  end

  def downcase_topic
    self.topic.downcase!
  end

  def extract_keywords
    candidates = probable_nouns.inject(Hash.new(0)) {|h,i| h[i] += 1; h }
    self.keywords = candidates.select{|k,v| v > 1}.map(&:first)
  end

  def probable_nouns
    re = Regexp.union(PREDICATE_INDICATORS.map{|w| /\s*\b#{Regexp.escape(w)}\b\s*/i})
    candidates = self.corpus.split(re).flatten
    candidates = candidates.map{|candidate| candidate.gsub(/[^a-zA-Z]/, " ")}.compact
    candidates = candidates.map(&:split).map(&:last).flatten.compact.map(&:downcase)
  end

  def random_fact
    facts.sample
  end

  def relational_facts(subtopic)
    corpus.select do |sentence|
      placement = sentence =~ /#{subtopic}/i
      placement && placement.to_i < 50
    end
  end

  def targeted_fact_candidates(subtopic)
    (facts.select{|fact| fact =~ /#{subtopic}/i} + corpus.select{|sentence| sentence =~ /#{subtopic}/i}).reject{|candidate| candidate.size < 50}
  end

  def targeted_fact(subtopic)
    targeted_fact_candidates(subtopic).sample
  end

  def relational_fact(subtopic)
    relational_facts(subtopic).sample
  end

  def facts
    @facts ||= corpus.select{ |sentence| sentence.include?("is a") || sentence.include?("was") }
  end

  def inspect
    %{#<Alice::Context _id: #{self.id}", topic: "#{self.topic}", keywords: #{self.keywords.count}, is_current: #{is_current}, expires_at: #{self.expires_at}"}
  end

end
