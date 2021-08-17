require "rails_helper"

RSpec.describe Types::QueryType do
  describe 'users' do
    let!(:users) { create_pair(:user) }
    let!(:projects) { create_pair(:project, user: current_user) }
    let(:current_user) { users.first }
    let(:user) { users.last }
    let(:current_user_query) do
      "query { user(id: #{current_user.id}) { name projects { userId } } }"
    end
    let(:user_query) do
      "query { user(id: #{user.id}) { name projects { userId } } }"
    end
    let(:users_query) do
      %(query
              {
                users { 
                        name 
                      } 
              }
      )
    end
    let(:current_user_result) do
      GraphqlSchema.execute(current_user_query).as_json
    end
    let(:user_result) do
      GraphqlSchema.execute(user_query).as_json
    end
    let(:users_result) do
      GraphqlSchema.execute(users_query).as_json
    end

    context 'all' do
      it 'returns all users' do
        expect(users_result.dig('data', 'users')).to match_array(
          users.map { |user| {"name" => user.name } }
        )
      end
    end

    context 'one' do
      it 'returns the current user\'s name' do
        expect(current_user_result.dig('data', 'user', 'name')).to eq(current_user.name)
      end

      it 'returns the current user\'s projects' do
        expect(current_user_result.dig('data', 'user', 'projects')).to match_array(
          projects.map { |project| { "userId" => project.user_id } }
        )
      end
    end

    context 'when user projects does not contain current user projects' do
      it 'returns user name' do
        expect(user_result.dig('data', 'user', 'name')).to eq(user.name)
      end

      it 'returns user projects' do
        expect(user_result.dig('data', 'user', 'projects')).not_to match_array(
          projects.map { |project| { "userId" => project.user_id } }
        )
        expect(user_result.dig('data', 'user', 'projects')).to match_array([])
      end
    end
  end
end
