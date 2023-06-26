class MicrosoftTaskSyncService < ExternalTaskSyncService
  TASK_STATUS_MAPPING = {
    "notStarted" => false,
    "inProgress" => false,
    "completed" => true,
  }

  def sync
    access_token = user.external_access_tokens.find_by(provider: "microsoft")&.access_token
    return if access_token.nil?

    graph = MicrosoftGraph.new(access_token)

    ms_tasks = graph.all_tasks

    ms_tasks.each do |ms_task|
      external_task = ExternalTodoTask.find_by(
        provider: "microsoft",
        external_task_id: ms_task["id"],
        user_id: user.id,
      )

      if external_task.present?
        task = external_task.task
        task.done = TASK_STATUS_MAPPING[ms_task["status"]]
        task.save!
        external_task.data = ms_task
        external_task.save!
      else
        users_list = user.lists.find_or_create_by!(name: ms_task["list"]["displayName"])
        task = users_list.tasks.create!(
          name: ms_task["title"],
          done: TASK_STATUS_MAPPING[ms_task["status"]],
        )
        external_task = task.create_external_todo_task(
          provider: "microsoft",
          external_task_id: ms_task["id"],
          external_list_id: ms_task["list"]["id"],
          list_id: users_list.id,
          user_id: user.id,
          data: ms_task,
        )
      end
    end
  end
end