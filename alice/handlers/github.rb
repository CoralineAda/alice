module Handlers
  class GitHub

    include PoroPlus
    include Behavior::HandlesCommands

    def issues
      issues = parser.issues
      if issues.any?
        message.response = issues.take(5).join("\n")
      else
        message.response = "No open bugs, hooray! If you find one, report it at #{ENV['ISSUES_URL']}"
      end
    end

    def commits
      message.response = parser.commits.take(5).join("\n")
    end

    def contributors
      message.response = "My contributors include #{parser.contributors.to_sentence}."
    end

    private

    def parser
      Parser::GitHub.fetch
    end

  end
end
