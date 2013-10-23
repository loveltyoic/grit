require 'fileutils'
module GitCafe
  class GitApi < Grape::API
    
    version 'v1', :using => :path
    format :json
    
    git_root_path = '/Users/loveltyoic/gitcafe'

    resource :commits do
      desc 'List all commits.'
      params do
        requires :path, :type => String
        requires :repo_name, :type => String
      end
      get '/' do
        commits = GitCafe::Commit.new(params[:path], params[:repo_name])
        commits.show
      end
      
    end

    resource :repos do

      desc "Create a new repository."
      params do
        requires :repo_name, :type => String
        requires :path, :type => String
        requires :bare, :type => Boolean
      end
      post '/' do
        repo = GitCafe::Repo.new(params[:path], params[:repo_name], params[:bare])
        repo.create
      end

      desc 'Show a repository.'
      params do
        requires :repo_name, :type => String
        requires :path, :type => String
      end
      get '/' do
        repo = GitCafe::Repo.new(params[:path], params[:repo_name], false)
        repo.show
      end

      desc 'Fork a repository.'
      params do 
        requires :path, :type => String
        requires :repo_name, :type => String
        requires :fork_path, :type => String
      end
      post '/:path/:repo_name/fork_bare' do
        repo = GitCafe::Repo.new(params[:path], params[:repo_name], true)
        repo.fork(params[:fork_path])
      end


      desc "Delete a repository."
      params do
        requires :repo_name, :type => String
        requires :path, :type => String
      end
      delete '/' do 
        repo = GitCafe::Repo.new(params[:path], params[:repo_name], false)
        repo.destroy
      end

    end

  end
end