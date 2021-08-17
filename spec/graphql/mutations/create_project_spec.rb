require 'rails_helper'

module Mutations
  RSpec.describe CreateProject, type: :request do
    let!(:user) { create(:user) }
    let(:project) { create(:project, user: user)}
    let(:query) do
      <<~GQL
      mutation createProject(input: { name: "#{project.name}", userId: "#{user.id}" }) { project { name id } }
      GQL
    end

    describe '.resolve' do
      it 'creates a project' do
        expect do
          post '/graphql', params: { query: query }
        end.to change { Project.count }.by(1)
        expect(response).to have_http_status(:successful)
        expect(user.projects).to eq([project])
      end
    end
  end
end
