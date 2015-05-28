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

    def get_related_users(user, relation, page)
      params = { query: { page: page, per_page: 100}}
      user_list = Github.get("/users/#{user}/#{relation}", params)
    end

    def get_rate_limit
      result = Github.get("/rate_limit")
      result = result['resources']['core']['remaining']
    end

    # def get_page_count(response)
    #   response['link'].split(", ")[1].match(/page=(\d+)/).captures.to_i
    # end

  end
end
