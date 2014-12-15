module Handlers
  class GitHub

    include PoroPlus
    include Behavior::HandlesCommands

    def issues
      message.set_response(parser.issues.take(5).join("\n"))
    end

    def commits
      message.set_response(parser.commits.take(5).join("\n"))
    end
  
    private

    def parser
      Parser::GitHub.new(*ENV['GITHUB_URL'].split('/')[-2..-1])
    end

  end
end

