require 'grit'
module GitCafe
  class Repo
    def initialize(username, repo_name)
      @repo = Grit::Repo.init("/Users/loveltyoic/gitcafe/#{username}/#{repo_name}")
    end

    def view_commits
      @repo.commits
    end

    def self.find(username, repo_name)
      @repo = Grit::Repo.new("/Users/loveltyoic/gitcafe/#{username}/#{repo_name}")
    end
  end
end

