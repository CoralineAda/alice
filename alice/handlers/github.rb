module Handlers
  class GitHub

    include PoroPlus
    include Behavior::HandlesCommands

    def issues
      message.set_response(issues)
    end

    private

    def parser
      Parser::Github.new(*ENV['GITHUB_URL'].split('/')[-2..-1])    
    end
    
    def issues
      parser.issues
    end

  end
end

