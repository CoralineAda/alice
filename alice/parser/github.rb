module Parser
  class GitHub

    attr_reader :user_name, :repo_name
    
    def self.fetch(user_name, repo_name)
      new(user_name, repo_name)
    end

    def initialize(user_name, repo_name)
      @user_name = user_name
      @repo_name = repo_name
    end
    
    def issues
      raw_issues = repo.rels[:issues].get.data
      raw_issues.map{ |issue| Issue.new(issue).to_s }
    end
    
    private
      
    def repo
      @repo = Octokit.repo("#{self.user_name}/#{self.repo_name}")
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
    
  end
end