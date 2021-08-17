require 'rails_helper'
require 'vcr_config'

RSpec.describe GithubService do
  before(:all) do
    login = 'dhh'
    @user_response = VCR.use_cassette('github_service_name') { GithubService.new(login).name }
    @repos_response = VCR.use_cassette('github_service_repos') { GithubService.new(login).repos }
  end

  describe '#name' do
    it 'returns the name of the user' do
      expect(@user_response[:name]).to eq('David Heinemeier Hansson')
    end

    it 'returns valid format' do
      expect(@user_response).to be_kind_of(ActionController::Parameters)
      expect(@user_response[:name]).to be_kind_of(String)
    end
  end

  describe '#repos' do
    it 'returns all repositories of the user' do
      repos = @repos_response[..2].map { |repo| repo[:name]}
      expect(repos).to eq(['actioncable', 'asset-hosting-with-minimum-ssl', 'bundler'])
    end

    it 'returns valid format' do
      expect(@repos_response).to be_kind_of(Array)
      expect(@repos_response[0]).to be_kind_of(ActionController::Parameters)
    end
  end
end
