module Parser
  class GitHub

    attr_reader :repo_path

    DEFAULT_REPO_PATH = ENV['GITHUB_URL'].split('/')[-2..-1].join('/')

    def self.fetch(repo_path=DEFAULT_REPO_PATH)
      new(repo_path)
    end

    def initialize(repo_path)
      @repo_path = repo_path
    end

    def issues
      raw_issues = repo.rels[:issues].get.data
      raw_issues.map{ |issue| Issue.new(issue).to_s }
    end

    def commits
      raw_commits = repo.rels[:commits].get.data
      raw_commits.map{ |commit| Commit.new(commit[:commit]).to_s }
    end

    def contributors
      stats = Octokit::Client.new.contributors_stats(repo_path).map(&:author).map(&:login)
    end

    private

    def repo
      @repo = Octokit.repo(repo_path)
    end

    class Issue

      def initialize(raw_issue)
        @raw_issue = raw_issue
      end

      def to_s
        "#{raw_issue[:number]}: #{raw_issue[:title]} (Filed by #{raw_issue[:user][:login]} on #{raw_issue[:created_at]})"
      end

      private

      attr_reader :raw_issue
    end

    class Commit

      def initialize(raw_commit)
        @raw_commit = raw_commit
      end

      def to_s
        "#{raw_commit[:message].lines.first} (Committed by #{raw_commit[:author][:name]} (#{raw_commit[:author][:email]}) on #{raw_commit[:author][:date]})"
      end

      private

      attr_reader :raw_commit

    end
  end
end
