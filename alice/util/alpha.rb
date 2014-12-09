require 'wolfram-alpha'

module Util
  class Alpha

    attr_accessor :question
    attr_reader :answer

    CLIENT_OPTIONS = { format: 'plaintext' }

    def initialize(question)
      @question = question
    end

    def answer
      return unless ENV['ALPHA_ENABLED']
      return unless result_pod = response.find{|pod| pod.title == "Result"}
      result_pod.subpods[0].plaintext.gsub("\n", " ")
    end

    private

    def client
      WolframAlpha::Client.new(ENV['ALPHA_APP_KEY'], CLIENT_OPTIONS)
    end

    def response
      @response ||= client.query(self.question)
    end

  end
end