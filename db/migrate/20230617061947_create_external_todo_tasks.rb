class CreateExternalTodoTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :external_todo_tasks do |t|
      t.string :provider
      t.string :external_task_id
      t.string :external_list_id
      t.references :task, foreign_key: true
      t.string :list_id
      t.string :user_id
      t.jsonb :data
      t.timestamps
    end

    add_index :external_todo_tasks, [:external_task_id, :task_id], unique: true
  end
end
