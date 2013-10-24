require 'grit'
module GitCafe
  class Repo
    attr_reader :repo_name, :path, :bare, :size, :result

    def self.create(path, repo_name, bare)
      path = File.join(path, repo_name)
      Dir.chdir('/Users/loveltyoic/gitcafe') do
        if File.exist?(path) || File.exist?(path+'.git')
          return {
            result: false,
            message: 'Repo already exists.'
          }
        else
          if bare
            path += '.git'
            Grit::Repo.init_bare(path)
          else
            Grit::Repo.init(path)
          end
        end
        {
          result: true,
          data: {
            name: repo_name,
            bare: bare,
            path: path,
            filesize: File.size(path)
          }
        }
      end
    end

    def initialize(path, repo_name)
      @repo_name = repo_name
      @path = File.join(path, repo_name)
      @branches = []
      Dir.chdir('/Users/loveltyoic/gitcafe') do
        if File.exist?(@path) 
          @bare = false 
        elsif File.exist?(@path+'.git')
          @path += '.git'
          @bare = true
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
    

    def show    
      {
        result: true,
        data: {
          name: @repo_name,
          bare: @bare,
          path: @path,
          filesize: @size
        }
      }
    end

    def fork(path)
      Dir.chdir('/Users/loveltyoic/gitcafe') do
        path = File.join(path, @repo_name+'.git')
        @repo.fork_bare(path)
        @size = File.size(path)
      end
      {
        result: true,
        data: {
          name: @repo_name,
          bare: true,
          path: path,
          filesize: @size
        }
      }
    end

    def destroy
      Dir.chdir('/Users/loveltyoic/gitcafe') do
        FileUtils.rm_rf(@path)
      end
      {
        result: true
      }
    end

    def branches
      Dir.chdir('/Users/loveltyoic/gitcafe') do
        @repo.heads.each { |head| @branches << head.name }
      end
      {
        result: true,
        data: {
          branches: @branches
        }
      }
    end

  
  end
end

