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
      if commits = parser.commits
        message.response = commits.take(5).join("\n")
      else
        message.response = "The GitHub API is being ornery again, sorry."
      end
    end

    def contributors
      if contributors = parser.contributors
        message.response = "My contributors include #{contributors.to_sentence}."
      else
        message.response = "GitHub and I aren't talking right now. Their API hates me, I think."
      end
    end

    private

    def parser
      Parser::GitHub.fetch
    end

  end
end
