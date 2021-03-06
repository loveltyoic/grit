require "rubygems"
require "bundler/setup"
require 'goliath'
require 'grape'
require './app/gitcafe/git_api'
require './app/gitcafe/repo'
require './app/gitcafe/commit'

class Server < Goliath::API

  def response(env)
    GitCafe::GitApi.call(env)
  end

end