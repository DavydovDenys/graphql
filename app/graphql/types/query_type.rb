# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # /users
    field :users, [Types::UserType], null: false, description: 'Returns a list of all users'

    def users
      User.all.order(created_at: :desc)
    end

    # /user
    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end

    def user(id:)
      User.find(id)
    end

    # /projects
    field :projects, [Types::ProjectType], null: false

    def projects
      Project.all
    end

    # /users/:id/projects
    field :user_projects, [Types::ProjectType], null: false do
      argument :id, ID, required: true
    end

    def user_projects(id:)
      Project.where(user_id: id)
    end
  end
end
