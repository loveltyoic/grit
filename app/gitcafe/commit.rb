require 'grit'
module GitCafe
  class Commit
    def initialize(path, repo_name)
      @path = File.join(path,repo_name)
      Dir.chdir('/Users/loveltyoic/gitcafe') do
        if File.exist?(@path) 
        elsif File.exist?(@path+'.git')
          @path += '.git'
        else
          return {
            result: false, 
            message: 'Repo not exists!'
          }
        end
        @repo = Grit::Repo.new(@path)
        @size = File.size(@path)
      end
    end

    def index
      commits = []
      @repo.commits.each do |commit|
        commits << {
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
      {
        result: true,
        data: commits
      }
    end

    def show(id)
      commit = @repo.commit(id)
      tree = commit.tree
      contents = tree.contents
      blobs = []
      contents.each do |blob|
        blobs << {
          blob: blob.id,
          name: blob.name,
          size: blob.size,
          content: blob.data
        }
      end
      {
        result: true,
        data: blobs
      }
    end

  end
end