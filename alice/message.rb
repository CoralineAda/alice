class Message

  attr_accessor :sender_nick, :recipient_nick, :type, :response, :trigger

  def initialize(sender_nick, trigger)
    self.sender_nick = sender_nick
    self.trigger = trigger
  end

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

  def is_sudo?
    Alice::Util::Mediator.op?(sender_nick)
  end

  def recipient
    @recipient ||= User.find_or_create(self.recipient_nick)
  end

  def sender
    @sender ||= User.find_or_create(self.sender_nick)
  end

  def set_response(content)
    self.response = content
    self
  end

end