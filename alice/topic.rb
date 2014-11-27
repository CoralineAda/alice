class Topic

  attr_reader :dictionary
  attr_accessor :subject

  def initialize(topic=nil, dictionary=nil)
    @subject = topic || select_subject
  end

  def dictionary
    @dictionary ||= MarkyMarkov::Dictionary.new('dictionary')
  end

  def intro
    "I was #{verb} #{subject}."
  end

  def reset
    self.subject = select_subject
  end

  def select_subject
    dictionary.generate_n_words(100).split.select{|w| w.size > 7}.sample.gsub(/[^a-zA-Z]/,'')
  end

  def support
    support = ::Sanitize.fragment(Wikipedia.find(subject).sanitized_content)
    support = support.split(/[\.\:\[\]\n\*\=]/)
    support = support.reject{|w| w == " "}
    support = support.reject(&:empty?)
    support = support.map(&:strip)
    support = support.reject{|sentence| sentence.size < 30}
    support = support.select{|sentence| sentence.include? subject}
    support = support.sample
    support && support << "." || "Never mind. Let's talk about something else."
  end

  def markov_support
    dictionary.generate_n_sentences(2)
  end

  def intro
    [
      "I was just talking about",
      "I was about to say something about",
      "I was recently reminded of",
      "I was talking to a friend about",
      "I was wanting to ask you about",
      "I have been thinking a lot about",
      "I am interested in your opinion on",
      "I'd like to hear your opinions on",
      "I can't stop thinking about"
    ].sample + " #{subject}."
  end

end
