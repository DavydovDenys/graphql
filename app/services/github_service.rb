# frozen_string_literal: true

require 'net/http'

class GithubService
  USERS_API = 'https://api.github.com/users/'
  REPOS     = '/repos'
  def initialize(login)
    @login = login.delete(' ')
  end

  def name
    url                       = URI([USERS_API, @login].join)
    @name                     = fetch_data(url)['name']
    git_name_params           = ActionController::Parameters.new({ git_name: { name: @name || 'NA' } })
    git_name_params.require(:git_name).permit(:name)
  end

  def repos
    url   = URI([USERS_API, @login, REPOS].join)

    repos = fetch_data(url).map { |repo| repo['name'] }

    params = []
    repos.each do |repo|
      repo_params           = ActionController::Parameters.new({ repo_name: { name: repo } })
      permitted_repo_params = repo_params.require(:repo_name).permit(:name)
      params << permitted_repo_params
    end

    params
  end

  private

  def fetch_data(url)
    reponse = Net::HTTP.get(url)
    json    = JSON.parse(reponse)

    if json.is_a?(Hash) && json.key?('message') && url.to_s.end_with?('repos')
      json = ['name' => 'N/A']
    elsif json.is_a?(Hash) && json.key?('message')
      json['message']
    end
    json
  end
end
