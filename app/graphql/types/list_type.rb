# frozen_string_literal: true

module Types
  class ListType < Types::BaseObject
    field :id, ID, null: false, description: "List id string"
    field :name, String, null: false, description: "List's name"
    field :user, Types::UserType, null: false, description: "User of the list"
    field :tasks, [Types::TaskType], null: true, description: "List Tasks"
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
