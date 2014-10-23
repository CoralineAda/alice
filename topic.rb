class Topic

  def initialize(dictionary=nil)
    @dictionary = dictionary || default_dictionary
  end

  def default_dictionary
    MarkyMarkov::Dictionary.new('dictionary')
  end

  def intro
    "I was #{verb} #{subject}."
  end

  def subject
    @topic_subject ||= dictionary.generate_n_words(100).split.select{|w| w.size > 7}.sample.gsub(/[^a-zA-Z]/,'')
  end

  def support
    support = ::Sanitize.fragment(Wikipedia.find(topic_subject).sanitized_content)
    support = support.split(/[\.\:\[\]\n\*\=]/)
    support = support.reject{|w| w == " "}
    support = support.reject(&:empty?)
    support = support.reject{|sentence| sentence.size < 30}
    support = support.sample
    support && support.strip << "." || "Never mind. Let's talk about something else."
  end

  def intro
    [
      "I was just talking about",
      "I was about to say something about",
      "I was recently reminded of",
      "I was talking to a friend about",
      "I was wanting to ask you about",
      "I was thinking a lot about",
      "I was interested in your opinion on",
      "I'd like to hear your opinions on",
      "I can't stop thinking about"
    ].sample = " #{subject}."
  end

end
