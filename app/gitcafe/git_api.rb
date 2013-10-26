require 'fileutils'
module GitCafe
  class GitApi < Grape::API
    
    version 'v1', :using => :path
    format :json
    
    git_root_path = '/Users/loveltyoic/gitcafe'

    resource :commits do
      desc 'List all commits of a branch'
      params do
        requires :path, :type => String
        requires :repo_name, :type => String
        requires :branch, :type => String
      end
      get '/' do
        commits = GitCafe::Commit.new(params[:path], params[:repo_name])
        commits.index(params[:branch])
      end

      desc 'Show a commit'
      params do
        requires :path, :type => String
        requires :repo_name, :type => String
        requires :id, :type => String
      end
      get '/:path/:repo_name' do
        commits = GitCafe::Commit.new(params[:path], params[:repo_name])
        commits.show(params[:id])
      end

      desc 'The commit diff for the given commit.'
      params do 
      requires :path, :type => String
        requires :repo_name, :type => String
        requires :id, :type => String
      end
      get '/:path/:repo_name/:id/diff' do
        commits = GitCafe::Commit.new(params[:path], params[:repo_name])
        commits.diff(params[:id])
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
        repo = GitCafe::Repo.create(params[:path], params[:repo_name], params[:bare])
      end

      desc 'Show a repository.'
      params do
        requires :repo_name, :type => String
        requires :path, :type => String
      end
      get '/' do
        repo = GitCafe::Repo.new(params[:path], params[:repo_name])
        repo.show
      end

      desc 'Show all branches of a repository.'
      params do 
        requires :repo_name, :type => String
        requires :path, :type => String
      end
      get '/branches' do 
        repo = GitCafe::Repo.new(params[:path], params[:repo_name])
        repo.branches
      end

      desc 'Fork a repository.'
      params do 
        requires :path, :type => String
        requires :repo_name, :type => String
        requires :fork_path, :type => String
      end
      post '/:path/:repo_name/fork_bare' do
        repo = GitCafe::Repo.new(params[:path], params[:repo_name])
        repo.fork(params[:fork_path])
      end


      desc "Delete a repository."
      params do
        requires :repo_name, :type => String
        requires :path, :type => String
      end
      delete '/' do 
        repo = GitCafe::Repo.new(params[:path], params[:repo_name])
        repo.destroy
      end

    end

  end
end