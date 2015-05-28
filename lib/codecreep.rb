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
        user_info = @github.get_user_info(user)
        user_data = {
          name: user_info['login'],
          homepage: user_info['html_url'],
          company: user_info['company'],
          follower_count: user_info['followers'],
          following_count: user_info['following'],
          repo_count: user_info['public_repos']
        }
        User.create(user_data)
        puts user_data
      end
    end

    def create_all_users(user_list)
      user_list.each do |user|
        self.create_user(user)
        followers = list_all_related_users(user, "followers")
        followers.each do |follower|
          self.create_user(follower)
        end
        following = list_all_related_users(user, "following")
        following.each do |follow|
          self.create_user(follow)
        end
      end
    end

    def list_all_related_users(user, relation)
      user_list = []
      page = 1
      response = @github.get_related_users(user, relation, page)
      while response.length != 0
        user_list += response.map {|x| x['login']}
        page += 1
        response = @github.get_related_users(user, relation, page)
      end
      user_list + response.map {|x| x['login']}
    end

    def fetch
      # aftravis, Diavolo, jb55, adriennefriend, b-towers-atl, agam, brossetti1, avodonosov, vsedach, augustdaze
      user_list = self.get_user_list 
      self.create_all_users(user_list)
    end

    def analyze
    end

  end
end

app = Codecreep::App.new
binding.pry
