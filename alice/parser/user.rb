module Parser
  class User
    def self.fetch(topic)
      if user = ::User.from(topic)
        content = user_methods(user).map do |method|
          string_from_user_info(user, method)
        end.flatten.compact.reject(&:empty?)
        content << user.factoids.map(&:text)
        return unless content.any?
        content.flatten.join('. ').gsub('.. ', '. ')
      else
        ""
      end
    end

    def self.user_methods(user)
      user.methods.select { |m| /^info_/.match(m) && user.method(m).arity.zero? }
    end

    def self.string_from_user_info(user, method_name)
      info = user.public_send(method_name)
      is_boolean = /\?/.match(method_name)
      return(info) unless is_boolean
      info ? positive_response_for(user, method_name) : negative_response_for(user, method_name)
    rescue
      ""
    end

    def self.scrub_method_name(method_name)
      method_name.to_s.gsub(/^info_|\?/, '').gsub('_', ' ')
    end

    def self.positive_response_for(user, method)
      "#{user.current_nick} is #{scrub_method_name(method)}".gsub(" is can ", " can ").gsub(" is is ", " is ")
    end

    def self.negative_response_for(user, method)
      if method =~ /can/
        "#{user.current_nick} #{scrub_method_name(method)}".gsub(" can ", " cannot ")
      else
        "#{user.current_nick} is #{scrub_method_name(method)}".gsub(" is ", " is not " )
      end
    end

  end
end
