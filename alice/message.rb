class Message

  attr_accessor :sender_nick, :recipient_nick, :type, :trigger, :response_type, :response

  def initialize(sender_nick, trigger)
    self.sender_nick = sender_nick
    self.trigger = trigger
  end

  def content
    self.trigger
  end

  def filtered(text)
    return text if filters.empty?
    return text if sender.remove_expired_filters
    eval("Alice::Filters::#{filters.sample.to_s.classify}").new.process(text) || text
  end

  def filters
    @filters ||= self.sender.filters
  end

  def is_emote?
    self.type == "emote"
  end

  def is_sudo?
    Alice::Util::Mediator.op?(self.sender_nick)
  end

  def recipient
    @recipient ||= User.find_or_create(self.recipient_nick)
  end

  def response
    @response ||= filtered(Response.from(self).try(:response))
  end

  def sender
    @sender ||= User.find_or_create(self.sender_nick)
  end

  def set_response(content)
    @response = filtered(content)
    self
  end

  private

  def response_reference
    @response_reference ||= Response.from(self)
  end

end