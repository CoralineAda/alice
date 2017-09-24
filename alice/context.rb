class Context
  require 'thread'
  include Mongoid::Document

  field :topic
  field :keywords, type: Array, default: []
  field :corpus, type: Array, default: []
  field :expires_at, type: DateTime
  field :has_user, type: Boolean, default: false
  field :is_current, type: Boolean
  field :is_ephemeral, type: Boolean, default: false
  field :spoken, type: Array, default: []
  field :created_at, type: DateTime

  before_create :downcase_topic, :define_corpus, :extract_keywords, :set_user
  before_create :set_expiry

  validates_uniqueness_of :topic, case_sensitive: false

  store_in collection: "alice_contexts"

  AMBIGUOUS = "That may refer to several different things. Can you clarify?"
  MINIMUM_FACT_LENGTH = 15
  TTL = 30

  attr_accessor :corpus_from_user, :query

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

  def self.find_or_create(topic, query="")
    context = from(topic) || new(topic: topic)
    unless query.empty?
      context.query = query.downcase.gsub(ENV['BOT_NAME'], "")
      if context.persisted?
        context.define_corpus
        context.save
      end
    end
    context
  end

  def self.most_recent
    Context.all.order_by(updated_at: 'desc').first
  end

  def self.with_pronouns_matching(pronouns)
    candidates = Context.where(:has_user => true).order_by(:updated_at => 'desc')
    candidates.each do |candidate|
      return candidate if (["they", "them", "their"] & pronouns).any?
      return candidate if (candidate.context_user.pronouns_enumerated & pronouns).any?
    end
    return nil
  end

  def self.with_topic_matching(topic)
    ngrams = Grammar::NgramFactory.new(topic).omnigrams
    ngrams = ngrams.map{|g| g.join(' ')}
    if exact_match = any_in(topic: ngrams).first
      return exact_match
    end
    return nil
  end

  def self.with_keywords_matching(topic)
    topic_keywords = keywords_from(topic)
    any_in(keywords: topic_keywords + [topic_keywords.join(" ")]).sort do |a,b|
      (a.keywords & topic_keywords).count <=> (b.keywords & topic_keywords).count
    end.last
  end

  def self.from(*topic)
    topic.join(' ') if topic.respond_to?(:join)
    context = with_topic_matching(topic)
    context ||= with_keywords_matching(topic)
    context
  end

  def ambiguous?
    self.corpus && self.corpus.map{|fact| fact.include?("may refer to") || fact.include?("disambiguation") }.any?
  end

  def context_user
    @context_user ||= User.from(self.topic)
  end

  def corpus_accessor
    return corpus unless is_ephemeral
    self.corpus = nil
    define_corpus
  end

  def current!
    Context.all.each{|context| context.update_attribute(:is_current, false) }
    update_attributes(is_current: true, expires_at: DateTime.now + TTL.minutes)
  end

  def describe
    return AMBIGUOUS if ambiguous?
    fact = facts.select{ |sentence| near_match(self.topic, sentence) }.first
    record_spoken(fact)
    fact
  end

  def define_corpus
    self.corpus = begin
      fetch_content_from_sources.compact
        .reject{ |s| s.empty? }
        .reject{ |s| s.include?("may refer to") || s.include?("disambiguation") }
        .reject{ |s| s.size < (self.corpus_from_user ? self.topic.length + 1 : MINIMUM_FACT_LENGTH)}
        .map{ |s| Grammar::LanguageHelper.to_third_person(s.gsub(/^\**/, "")) }
        .uniq || []
    rescue Exception => e
      Alice::Util::Logger.info "*** Unable to fetch corpus for \"#{self.topic}\": #{e}"
      Alice::Util::Logger.info e.backtrace
      []
    end
  end

  def declarative_fact(subtopic, speak=true)
    return AMBIGUOUS if ambiguous?
    fact_candidates = relational_facts(subtopic).select do |sentence|
      has_info_verb = sentence =~ /\b#{(Grammar::LanguageHelper::INFO_VERBS + ["it", "they", "he", "she"])* '|\b'}/ix
      placement = position_of(subtopic.downcase, sentence.downcase)
      has_info_verb && placement && placement.to_i < 100
    end
    factogram = fact_candidates.inject({}) do |histogram, fact|
      index = declarative_index(fact) + relevance_sort_value(fact)
      histogram[index] ||= []
      histogram[index] << fact
      histogram
    end
    if final_candidates = factogram[factogram.keys.sort.first]
      fact = final_candidates.sample
      record_spoken(fact) if speak
      fact
    else
      nil
    end
  end

  def expire
    expire! if (self.expires_at.nil? || self.expires_at < DateTime.now)
  end

  def facts
    spoken_facts = corpus_accessor.to_a.select{|sentence| spoken.include? sentence}
    if spoken_facts.count == corpus_accessor.to_a.count # We've said all we can, time to repeat ourselves
      corpus_accessor.to_a.sort do |a,b|
        is_was_sort_value(a) <=> is_was_sort_value(b)
      end.uniq
    else
      corpus_accessor.to_a.reject{|sentence| spoken.include? sentence}.sort do |a,b|
        is_was_sort_value(a) <=> is_was_sort_value(b)
      end.uniq
    end
  end

  def has_spoken_about?(topic)
    self.spoken.to_s.downcase.include?(topic.downcase)
  end

  def inspect
    %{#<Context _id: #{self.id}", topic: "#{self.topic}", keywords: #{self.keywords}, is_current: #{is_current}, expires_at: #{self.expires_at}"}
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
    fact = targeted_fact_candidates(subtopic).first
    record_spoken(fact) if spoken
    fact
  end

  private

  def declarative_index(sentence)
    sentence =~ Grammar::LanguageHelper::DECLARATIVE_DETECTOR || 1000
  end

  def downcase_topic
    self.topic.downcase!
  end

  def extract_keywords
    self.keywords += begin
      parsed_corpus = Grammar::SentenceParser.parse(corpus.join(' '))
      candidates = parsed_corpus.nouns + parsed_corpus.adjectives
      candidates = candidates.inject(Hash.new(0)) {|h,i| h[i] += 1; h }
      candidates.select{|k,v| v > 1}.map(&:first).map(&:downcase).uniq
    rescue
      []
    end
  end

  def expire!
    update_attributes(is_current: false, spoken: [])
  end

  def fetch_content_from_sources
    if @content = Parser::User.fetch(topic)
      self.corpus_from_user = true
      self.is_ephemeral = true
      return @content
    end

    @content ||= []

    mutex = Mutex.new
    threads = []

    threads << Thread.new() do
      c = Parser::Alpha.fetch(topic).to_s
      mutex.synchronize { @content << c }
    end

    threads << Thread.new() do
      c = Parser::Google.fetch_all(self.query) unless self.query.nil? || self.query.empty? || self.query == self.topic
      mutex.synchronize { @content << c }
    end

    threads << Thread.new() do
      c = Parser::Google.fetch_all("facts about #{topic}")
      mutex.synchronize { @content << c }
    end

    threads << Thread.new() do
      c = Parser::Wikipedia.fetch_all(topic)
      mutex.synchronize { @content << c }
    end

    threads.each(&:join)
    @content = @content.flatten.map{ |fact| Sanitize.clean(fact.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')).strip }.uniq
    @content = @content.reject{ |fact| Grammar::SentenceParser.parse(fact).verbs.empty? }
    @content = @content.reject{ |fact| fact =~ /click/i || fact =~ /website/i }
    @content
  end

  def is_was_sort_value(element)
    (
      position_of("is", element) ||
      position_of("was", element) ||
      position_of("are", element) ||
      position_of("were", element) ||
      position_of("be", element) ||
      100
    ) - 100
  end

  def relevance_sort_value(element)
    facts.index(element) && facts.index(element) - 25 || 0
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
    @relational_facts ||= begin
      subtopic_ngrams = Grammar::NgramFactory.new(subtopic).omnigrams
      subtopic_ngrams = subtopic_ngrams.map{|g| g.join(' ')}.reverse
      candidates = subtopic_ngrams.map{ |ngram| facts.select{|fact| fact =~ /#{ngram}/i} }.compact.flatten
      candidates.select do |sentence|
        placement = position_of(subtopic.downcase, sentence.downcase)
        placement && placement.to_i < 100
      end.uniq
    end
  end

  def set_expiry
    self.expires_at = DateTime.now + TTL.minutes
  end

  def set_user
    self.has_user = !!User.from(self.topic)
    return true
  end

  def targeted_fact_candidates(subtopic)
    subtopic_ngrams = Grammar::NgramFactory.new(subtopic).omnigrams
    subtopic_ngrams = subtopic_ngrams.map{|g| g.join(' ')}.reverse
    subtopic_ngrams.map{ |ngram| facts.select{|fact| fact =~ /#{ngram}/i} }.compact.flatten
  end
end
