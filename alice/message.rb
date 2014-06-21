class Message

  include PoroPlus

  attr_accessor :sender_nick, :recipient_nick, :type, :response, :trigger

  def filtered
    return self.response unless sender.remove_filter?
    return self.response unless filters
    filters.inject([]) do |processed, filter|
      processed[0] = eval("Alice::Filters::#{filter.to_s.classify}").new.process(processed.first || self.response)
      processed
    end.first
  end

  def filters
    @filters ||= self.sender.filters.any?
  end

  def is_emote?
    self.response.is_emote?
  end

  def sender
    @sender ||= User.find_or_create(self.sender_nick)
  end

end