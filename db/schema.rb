# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140210174042) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.string   "title"
    t.datetime "start_at"
    t.string   "status"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
  end

  add_index "events", ["uuid"], name: "index_events_on_uuid", unique: true, using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["uuid"], name: "index_organizations_on_uuid", unique: true, using: :btree

  create_table "students", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id",                     null: false
  end

  add_index "students", ["email"], name: "index_students_on_email", unique: true, using: :btree
  add_index "students", ["organization_id"], name: "index_students_on_organization_id", using: :btree
  add_index "students", ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true, using: :btree

  create_table "timeline_interactions", force: true do |t|
    t.integer  "interaction_id",   null: false
    t.string   "interaction_type", null: false
    t.integer  "timeline_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timeline_interactions", ["timeline_id"], name: "index_timeline_interactions_on_timeline_id", using: :btree

  create_table "timeline_user_messages", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timelines", force: true do |t|
    t.datetime "start_at",   null: false
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timelines", ["event_id"], name: "index_timelines_on_event_id", using: :btree

end
