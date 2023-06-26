class Task < ApplicationRecord
  belongs_to :list
  has_one :external_todo_task, dependent: :destroy

  scope :not_done, -> { where(done: false) }
  scope :done, -> { where(done: true) }
end
