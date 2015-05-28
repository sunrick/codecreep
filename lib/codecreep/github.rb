require 'httparty'
require 'pry'

module Codecreep
  class Github
    include HTTParty
    base_uri 'https://api.github.com'
    basic_auth ENV['GH_USER'], ENV['GH_PASS']

    def get_user_info(user)
      user = Github.get("/users/#{user}")
    end

    def get_followers(user)
      followers = Github.get("/users/#{user}/followers?per_page=100")
    end

    def get_following(user)
      following = Github.get("/users/#{user}/following?per_page=100")
    end

    def get_rate_limit
      result = Github.get("/rate_limit")
      result = result['resources']['core']['remaining']
    end

    def pagination_followers(user, page_num)
      params = { query: {page: page_num}}
      Github.get("/users/#{user}/following")
      puts Github.get("/users/#{user}/following").headers
    end

    def header(user)
      response = Github.get("/users/#{user}/following").headers
      response['link'].split(", ")[1].match(/page=(\d+)/).captures.to_i
    end

    def get_page_count(response)
      response['link'].split(", ")[1].match(/page=(\d+)/).captures.to_i
    end

    def get_all_followers(user)
      followers = []
      page = 1
      response = self.list_followers(user, page)
      while response.length == 30
        followers += response
        page += 1
        response = self.list_followers(user, page)
      end
  end
end
