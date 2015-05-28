require 'httparty'
require 'pry'

module Codecreep
  class Github
    include HTTParty
    base_uri 'https://api.github.com'
    basic_auth ENV['GH_USER'], ENV['GH_PASS']

    def get_user_info(user)
      user = Github.get("/users/#{user}")
      result = {
        name: user['login'],
        homepage: user['html_url'],
        company: user['company'],
        follower_count: user['followers'],
        following_count: user['following'],
        repo_count: user['public_repos']
      }
    end

    def get_followers(user)
      result = []
      followers = Github.get("/users/#{user}/followers?per_page=100")
      followers.each do |follower|
        result << follower['login']
      end
      result
    end

    def get_following(user)
      result = []
      following = Github.get("/users/#{user}/following?per_page=100")
      following.each do |follow|
        result << follow['login']
      end
      result
    end

    def get_rate_limit
      result = Github.get("/rate_limit")
      result = result['resources']['core']['remaining']
    end

  end
end
