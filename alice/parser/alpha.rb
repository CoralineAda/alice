require 'wolfram-alpha'

module Parser
  class Alpha

    attr_accessor :question
    attr_reader :answer

    CLIENT_OPTIONS = { format: 'plaintext' }

    def self.fetch(topic)
      new(topic).answer
    end

    def initialize(question)
      @question = question
    end

    def answer
      return unless enabled?
      return unless result_pod = response.find{|pod| pod.title == "Result"}
      result_pod.subpods[0].plaintext.gsub("\n", " ")
    rescue Exception => e
      Alice::Util::Logger.info "*** Parser::Alpha: Unable to process \"#{self.question}\": #{e}"
      Alice::Util::Logger.info e.backtrace
      ""
    end

    private

    def client
      WolframAlpha::Client.new(ENV['ALPHA_APP_KEY'], CLIENT_OPTIONS)
    end

    def enabled?
      ENV['ALPHA_ENABLED'] == "true"
    end

    def response
      @response ||= client.query(self.question)
    end

  end
end
