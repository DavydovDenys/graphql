# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#new'
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: 'graphql#execute'
  end

  resources :users, only: %i[create new show]
  post '/graphql', to: 'graphql#execute'
end
