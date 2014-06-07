module Alice

  module Handlers

    class Twitter

      def self.minimum_indicators
        2
      end

      def self.process(sender, command)
        if subject = User.from(command)
          Alice::Handlers::Response.new(content: twitter_info_for(subject), kind: :reply)
        end
      end

      def self.twitter_info_for(subject)
        if subject.twitter_handle.present?
          "#{subject.primary_nick} is #{subject.twitter_handle} on Twitter (#{subject.twitter_url})"
        else
          "I don't know #{subject.primary_nick}'s handle on Twitter. They can set it using !twitter <handle> though."
        end
      end

    end

  end

end