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
      users = prompt("What users do you want to track?")
      result = users.split(", ")
    end

    def create_users(user_list)
      user_list.each do |user|
        user_data = @github.get_user_info(user)
        User.find_or_create_by(user_data)
        puts @github.get_rate_limit
      end
    end

    def create_followers(user_list)
      user_list.each do |user|
        followers = @github.get_followers(user)
        followers.each do |user|
          user_data = @github.get_user_info(user)
          User.find_or_create_by(user_data)
          puts @github.get_rate_limit
        end
        following = @github.get_following(user)
        following.each do |user|
          user_data = @github.get_user_info(user)
          User.find_or_create_by(user_data)
          puts @github.get_rate_limit
        end
      end
    end

    def create_all_users(user_list)
      self.create_users(user_list)
      self.create_followers(user_list)
    end

    def fetch
      user_list = ["aftravis", "Diavolo", "jb55", "adriennefriend", "b-towers-atl", "agam", "brossetti1", "avodonosov", "vsedach", "augustdaze"]
      self.create_all_users(user_list)
    end

  end
end
#comment
#["aftravis", "Diavolo", "jb55", "adriennefriend", "b-towers-atl", "agam", "brossetti1", "avodonosov", "vsedach", "augustdaze"]

app = Codecreep::App.new
binding.pry
