# frozen_string_literal: true

module Mutations
  class CreateProject < Mutations::BaseMutation
    argument :name, String, required: true
    argument :user_id, ID, required: true

    field :project, Types::ProjectType, null: false
    field :message, [String], null: false

    def resolve(name:, user_id:)
      user    = User.find(user_id)
      project = user.projects.create(name: name)
      {
        project: project,
        message: ["Project created by #{user.name}"]
      }
    end
  end
end
