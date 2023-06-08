# frozen_string_literal: true

module Types
  class TaskType < Types::BaseObject
    field :id, ID, null: false, description: "Task id string"
    field :name, String, null: true, description: "Task name"
    field :done, Boolean, null: true, description: "Task status"
    field :list, Types::ListType, null: false, description: "Task's List"
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
