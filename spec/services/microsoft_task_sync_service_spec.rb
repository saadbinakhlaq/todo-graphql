require "rails_helper"

RSpec.describe MicrosoftTaskSyncService do
  let(:user) { FactoryBot.create(:user) }

  describe "#sync", vcr: "microsoft_tasks" do
    before do
      user.external_access_tokens.create!(
        provider: "microsoft",
        access_token: "token"
      )
    end

    context "when user has no internal task" do
      it "creates internal tasks" do
        service = MicrosoftTaskSyncService.new(user)
        service.sync

        expect(user.lists.count).to eql 4
        expect(Task.count).to eql 13
        expect(ExternalTodoTask.count).to eql 13
      end
    end

    context "when user has internal tasks" do
      it "should sync tasks from Microsoft to Todo" do
        users_list = FactoryBot.create(:list, user_id: user.id, name: "Tasks")
        in_task = FactoryBot.create(:task, list_id: users_list.id, name: "Hello", done: false)
        external_task = FactoryBot.create(
          :external_todo_task,
          provider: "microsoft",
          external_task_id: "AQMkADAwATY0MDABLTgyODktY2U5NS0wMAItMDAKAEYAAAPQSNqTwhtyQoW6hAs-oHeQBwDUCYAPaDqZQKAN20RdQAPMAAACARIAAADUCYAPaDqZQKAN20RdQAPMAAZevboLAAAA",
          task_id: in_task.id,
          list_id: users_list.id,
          user_id: user.id,
        )

        service = MicrosoftTaskSyncService.new(user)
        service.sync
        expect(in_task.reload.done).to be_truthy
      end
    end
  end
end