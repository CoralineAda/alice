class Adapter

  def self.channel
    Alice.bot.bot.channels.first
  end

  def self.user_list
    Alice.bot.bot.user_list.to_a.map(&:nick)
  end

  def self.send_message(message)
    if message.is_emote?
      emote_to(message.recipient, message.response_text)
    else
      respond_to(message.recipient, message.response_text)
    end
  end

  def self.send_raw(message)
    text = Alice::Util::Sanitizer.process(message)
    text = Alice::Util::Sanitizer.initial_upcase(text)
    Alice.bot.bot.channels.first.msg(text)
  end

  def self.user_from(channel_user)
    User.with_nick_like(channel_user.user.nick)
  end

  def self.reply_to(channel_user, message)
    text = Alice::Util::Sanitizer.process(message)
    text = Alice::Util::Sanitizer.initial_upcase(text)
    text = user_from(channel_user).apply_filters(text) # HERE
    channel_user.reply(text)
  end

  def self.emote_to(channel_user, message)
    text = Alice::Util::Sanitizer.process(message)
    text = Alice::Util::Sanitizer.initial_downcase(text)
    channel_user.action_reply(text)
  end

end