require 'grit'
module GitCafe
  class Repo
    attr_reader :repo_name, :path, :bare, :size, :result
    def initialize(path, repo_name, bare)
      @repo_name = repo_name
      @path = File.join(path, repo_name)
      @bare = bare || false
    end

    def create
      Dir.chdir('/Users/loveltyoic/gitcafe') do
        if File.exist?(@path) || File.exist?(@path+'.git')
          return {
            result: false,
            message: 'Repo already exists.'
          }
        else
          if @bare
            @path = @path + '.git'
            Grit::Repo.init_bare("#{@path}")
          else
            Grit::Repo.init("#{@path}")
          end
          @size = File.size(@path)
        end
      end
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

    def show
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
        repo = Grit::Repo.new(@path)
        @size = File.size(@path)
      end
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
        if File.exist?(@path) 
        elsif File.exist?(@path+'.git')
          @path += '.git'
        else
          return {
            result: false, 
            message: 'Repo not exists!'
          }
        end
        repo = Grit::Repo.new(@path)
        path = File.join(path, @repo_name+'.git')
        repo.fork_bare(path)
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
  
  end
end

