# class Trigger

#   include Mongoid::Document

#   field :name
#   field :indicators, type: Array
#   field :stop_words, type: Array
#   field :canned_response
#   field :one_in_x_odds, type: Integer
#   field :last_said_at, type: DateTime

#     field :name
#     field :verbs, type: Array, default: []
#     field :indicators, type: Array, default: []
#     field :stop_words, type: Array, default: []
#     field :handler_class
#     field :handler_method
#     field :response_kind, default: :message

#     index({ indicators: 1 }, { unique: true })
#     index({ stop_words: 1 }, { unique: true })

#     validates_uniqueness_of :name
#     validates_presence_of :name, :handler_class

#     attr_accessor :message, :terms

#     def self.default
#       Command.new(handler_class: 'Handlers::Unknown')
#     end

#     def self.indicators_from(message)
#       Alice::Parser::NgramFactory.omnigrams_from(message)
#     end

#     def self.verb_from(message)
#       if verb = message.split(' ').select{|w| w[0] == "!"}.first
#         verb[1..-1]
#       end
#     end

#     def self.best_match(matches, indicators)
#       matches.sort do |a,b|
#         (a.indicators & indicators).count <=> (b.indicators & indicators).count
#       end.last
#     end

#     def self.from(message)
#       trigger = message.trigger.downcase.gsub(/[^a-zA-Z0-9\!\/\\\s]/, ' ')

#       if verb = verb_from(trigger)
#         match = any_in(verbs: verb).first
#       elsif indicators = indicators_from(trigger)
#         matches = with_indicators(indicators).without_stopwords(indicators)
#         match = best_match(matches, indicators)
#       end

#       match ||= default
#       match.message = message
#       match
#     end

#     def self.process(message)
#       from(message).invoke!
#     end

#     def self.with_indicators(indicators)
#       Command.in(indicators: indicators)
#     end

#     def self.without_stopwords(indicators)
#       Command.not_in(stop_words: indicators)
#     end

#     def invoke!
#       return message unless self.handler_class
#       eval(self.handler_class).process(message, self.handler_method || :process)
#     end

#     def terms
#       @terms || TermList.new(self.indicators)
#     end

#     def terms=(words)
#       @terms = TermList.new(words)
#     end

#     class TermList
#       attr_accessor :words
#       def initialize(terms=[])
#         self.words = convert(terms)
#       end

#       def <<(terms)
#         self.words << convert(terms)
#         self.words = self.words.flatten.uniq
#       end

#       def convert(terms)
#         [
#           terms.map(&:downcase),
#           terms.map{|term| Lingua.stemmer(term.downcase)}
#         ].flatten.uniq
#       end

#       def to_a
#         self.words
#       end

#     end

# end