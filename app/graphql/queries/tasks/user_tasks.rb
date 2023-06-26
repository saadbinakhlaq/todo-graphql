require 'search_object'
require 'search_object/plugin/graphql'

module Queries
  module Tasks
    class UserTasks < BaseQuery
      description "Get the Current User Tasks"

      type [Types::TaskType], null: true

      argument :done, Boolean, required: false, description: "Task Status"

      def resolve(done: nil)
        authenticate_user
        MicrosoftTaskSyncService.new(context[:current_user]).sync
        if done.nil?
          context[:current_user].lists.includes(:tasks).map(&:tasks).flatten
        else
          context[:current_user].lists.includes(:tasks).where(tasks: {done: done}).map(&:tasks).flatten
        end
      end
    end
  end
end
