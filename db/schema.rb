# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_17_063904) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "external_access_tokens", force: :cascade do |t|
    t.string "provider"
    t.bigint "user_id", null: false
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_external_access_tokens_on_user_id"
  end

  create_table "external_todo_tasks", force: :cascade do |t|
    t.string "provider"
    t.string "external_task_id"
    t.string "external_list_id"
    t.bigint "task_id"
    t.string "list_id"
    t.string "user_id"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_task_id", "task_id"], name: "index_external_todo_tasks_on_external_task_id_and_task_id", unique: true
    t.index ["task_id"], name: "index_external_todo_tasks_on_task_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "name", default: "default"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.bigint "list_id", null: false
    t.boolean "done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_tasks_on_list_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "external_access_tokens", "users"
  add_foreign_key "external_todo_tasks", "tasks"
  add_foreign_key "lists", "users"
  add_foreign_key "tasks", "lists"
end
