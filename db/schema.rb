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

ActiveRecord::Schema[8.0].define(version: 2025_11_19_061651) do
  create_table "attendance_records", force: :cascade do |t|
    t.integer "team_member_id", null: false
    t.date "record_date"
    t.integer "status"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_member_id"], name: "index_attendance_records_on_team_member_id"
  end

  create_table "hours_logs", force: :cascade do |t|
    t.integer "team_member_id", null: false
    t.date "log_date"
    t.decimal "hours"
    t.text "deliverable_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_member_id"], name: "index_hours_logs_on_team_member_id"
  end

  create_table "team_members", force: :cascade do |t|
    t.integer "team_id", null: false
    t.string "name"
    t.string "role"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_members_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "company"
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "waitlist_signups", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_waitlist_signups_on_email", unique: true
  end

  add_foreign_key "attendance_records", "team_members"
  add_foreign_key "hours_logs", "team_members"
  add_foreign_key "team_members", "teams"
end
