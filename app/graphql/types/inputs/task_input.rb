module Types
  module Inputs
    class TaskInput < BaseInputObject
      argument :name, String, required: true, description: "Task Name"
      argument :list_id, ID, required: false, description: "List Id to which it is to be input"
    end
  end
end
