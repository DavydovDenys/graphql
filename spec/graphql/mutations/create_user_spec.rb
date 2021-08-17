require 'rails_helper'

module Mutations
  RSpec.describe CreateUser, type: :request do
    let(:query) do
      <<~GRAPHQL
        mutation createUser(input: { name: "#{user.name}" }) { user { name } }
      GRAPHQL
    end
    let(:user) { create(:user) }

    describe '.resolve' do
      it 'creates a user' do
        expect do
          post '/graphql', params: { query: query }
        end.to change { User.count }.by(1)
        expect(response).to have_http_status(:successful)
      end
    end
  end
end
