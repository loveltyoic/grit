module GitCafe
  class GitApi < Grape::API
    
    version 'v1', :using => :path
    format :json
    
    git_root_path = '/Users/loveltyoic/gitcafe'

    resource :commits do
      desc 'List all commits.'
      get '/:repo_name' do
        repo = Grit::Repo.new("#{git_root_path}/#{params[:repo_name]}")
        commits = repo.commits
        commit_list = []
        commits.each do |commit|
          commit_list << {
            id: commit.id,
            parents: commit.parents,
            tree: commit.tree,
            author: commit.author,
            date: commit.authored_date,
            committer: commit.committer,
            committed_date: commit.committed_date,
            message: commit.message
          }
        end
        commit_list
      end
      
    end

    resource :repo do

      desc "Create a new repository."
      params {requires :repo_name, :type => String}
      post '/' do
        Grit::Repo.init("#{git_root_path}/#{params[:repo_name]}")
      end

    end



  end
end