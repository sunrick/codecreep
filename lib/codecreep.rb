$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'pry'

require 'codecreep/init_db'
require 'codecreep/github'
require 'codecreep/user'
require "codecreep/version"


module Codecreep

  class App

    def initialize
      @github = Github.new
    end

    def prompt(question)
      puts question
      result = gets.chomp
    end

    def get_user_list
      users = prompt("What users do you want to track? example: user1, user2, user3)")
      result = users.split(", ")
    end

    def create_user(user)
      unless User.exists?(name: user)
        user_data = @github.get_user_info(user)
        user_data = {
          name: user['login'],
          homepage: user['html_url'],
          company: user['company'],
          follower_count: user['followers'],
          following_count: user['following'],
          repo_count: user['public_repos']
        }
        User.create(user_data)
      end
    end

    def create_all_users(user_list)
      user_list.each do |user|
        self.create_user(user)
        followers = @github.get_followers
        followers.each do |follower|
          self.create_user(follower)
        end
        following = @github.get_following
        following.each do |follow|
          self.create_user(follow)
        end
      end
    end

    def fetch
      # aftravis, Diavolo, jb55, adriennefriend, b-towers-atl, agam, brossetti1, avodonosov, vsedach, augustdaze
      self.get_user_list 
      self.create_all_users(user_list)
    end

  end
end

app = Codecreep::App.new
binding.pry
