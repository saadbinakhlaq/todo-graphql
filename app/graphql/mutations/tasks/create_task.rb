module Mutations
  module Tasks
    class CreateTask < BaseMutation
      description "Create Task in user's list"

      argument :input, Types::Inputs::TaskInput, required: true

      field :task, Types::TaskType, null: false

      def resolve(input: nil)
        authenticate_user

        task = if input.list_id
          users_list = context[:current_user].lists.find(input.list_id)

          if users_list
            users_list.tasks.build(name: input.name)
          else
            raise GraphQL::ExecutionError.new("List Not Found")
          end
        else
          users_list = context[:current_user].lists.find_or_create_by(name: "default")
          users_list.tasks.build(name: input.name)
        end

        if task.save
          {task: task}
        else
          raise GraphQL::ExecutionError.new(task.errors.full_messages.join(', '))
        end
      end
    end
  end
end
