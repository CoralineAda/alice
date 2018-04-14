require 'wolfram-alpha'
require 'timeout'

module Parser
  class Alpha

    attr_accessor :question
    attr_reader :answer

    CLIENT_OPTIONS = { format: 'plaintext' }

    def self.fetch_all(topic)
      new(topic).answer
    end

    def initialize(question)
      @question = question
    end

    def answer
      return unless enabled?
      return unless result_pod = response.find{|pod| pod.title == "Result"}
      answer = result_pod.subpods[0].plaintext.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub("\n", " ")
      Alice::Util::Logger.info "*** Parser::Alpha: Answered \"#{self.question}\" with #{answer}"
      return [answer]
    rescue Exception => e
      Alice::Util::Logger.info "*** Parser::Alpha: Unable to process \"#{self.question}\": #{e}"
      Alice::Util::Logger.info e.backtrace
      return ["Hmm, that part of my brain is returning a #{e}"]
    end

    private

    def client
      WolframAlpha::Client.new(ENV['ALPHA_APP_KEY'], CLIENT_OPTIONS)
    end

    def enabled?
      ENV['ALPHA_ENABLED'] == "true"
    end

    def response
      return @response if @response
      Timeout::timeout(10) do
        @response = client.query(self.question)
      end
    rescue Timeout::Error
      @response = ""
    end

  end
end
