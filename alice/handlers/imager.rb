module Handlers
  class Imager
    include PoroPlus
    include Behavior::HandlesCommands

    def call
      message.set_response("Image: #{image}")
    end

    private

    def query
      command_string.content
    end

    def search
      Google::Search::Image.new(query: query)
    end

    def result
      search.first
    end

    def image
      result.uri
    end
  end
end
