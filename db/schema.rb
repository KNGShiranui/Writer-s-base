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

ActiveRecord::Schema.define(version: 2023_03_23_060118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignees", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "issue_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["issue_id"], name: "index_assignees_on_issue_id"
    t.index ["user_id"], name: "index_assignees_on_user_id"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name", limit: 100, default: "", null: false
    t.bigint "repository_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["repository_id"], name: "index_branches_on_repository_id"
  end

  create_table "commits", force: :cascade do |t|
    t.string "message", limit: 100, default: "", null: false
    t.bigint "user_id", null: false
    t.bigint "branch_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["branch_id"], name: "index_commits_on_branch_id"
    t.index ["user_id"], name: "index_commits_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name", limit: 100, default: "", null: false
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "branch_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["branch_id"], name: "index_documents_on_branch_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "name", limit: 100, default: "", null: false
    t.string "description", limit: 100
    t.string "status"
    t.string "priority"
    t.bigint "repository_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["repository_id"], name: "index_issues_on_repository_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.string "name", limit: 100, default: "", null: false
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 100, default: "", null: false
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.text "content"
    t.text "icon"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assignees", "issues"
  add_foreign_key "assignees", "users"
  add_foreign_key "branches", "repositories"
  add_foreign_key "commits", "branches"
  add_foreign_key "commits", "users"
  add_foreign_key "documents", "branches"
  add_foreign_key "documents", "users"
  add_foreign_key "issues", "repositories"
  add_foreign_key "repositories", "users"
end
