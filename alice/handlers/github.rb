module Handlers
  class GitHub

    include PoroPlus
    include Behavior::HandlesCommands

    def issues
      message.response = parser.issues.take(5).join("\n")
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
