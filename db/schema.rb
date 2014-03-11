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

ActiveRecord::Schema.define(version: 20140311200408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.integer  "student_id"
    t.integer  "option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["option_id"], name: "index_answers_on_option_id", using: :btree
  add_index "answers", ["student_id"], name: "index_answers_on_student_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "title"
    t.datetime "start_at"
    t.string   "status",          default: "available"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.text     "duration"
    t.integer  "teacher_id",                            null: false
  end

  add_index "events", ["teacher_id"], name: "index_events_on_teacher_id", using: :btree
  add_index "events", ["uuid"], name: "index_events_on_uuid", unique: true, using: :btree

  create_table "options", force: true do |t|
    t.string   "content"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
  end

  add_index "options", ["poll_id"], name: "index_options_on_poll_id", using: :btree
  add_index "options", ["uuid"], name: "index_options_on_uuid", unique: true, using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["uuid"], name: "index_organizations_on_uuid", unique: true, using: :btree

  create_table "organizations_teachers", id: false, force: true do |t|
    t.integer "organization_id", null: false
    t.integer "teacher_id",      null: false
  end

  create_table "polls", force: true do |t|
    t.string   "content"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     default: "available"
    t.string   "uuid"
  end

  add_index "polls", ["event_id"], name: "index_polls_on_event_id", using: :btree
  add_index "polls", ["uuid"], name: "index_polls_on_uuid", unique: true, using: :btree

  create_table "ratings", force: true do |t|
    t.float    "value",         default: 0.0
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["rateable_id", "rateable_type", "student_id"], name: "index_ratings_on_rateable_id_and_rateable_type_and_student_id", unique: true, using: :btree
  add_index "ratings", ["student_id"], name: "index_ratings_on_student_id", using: :btree

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
    t.string   "authentication_token"
    t.string   "avatar"
    t.string   "name"
  end

  add_index "students", ["email"], name: "index_students_on_email", unique: true, using: :btree
  add_index "students", ["organization_id"], name: "index_students_on_organization_id", using: :btree
  add_index "students", ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true, using: :btree

  create_table "teachers", force: true do |t|
    t.string   "name",                   default: "", null: false
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
    t.string   "avatar"
  end

  add_index "teachers", ["email"], name: "index_teachers_on_email", unique: true, using: :btree
  add_index "teachers", ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true, using: :btree

  create_table "thermometers", force: true do |t|
    t.integer  "event_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
  end

  add_index "thermometers", ["event_id"], name: "index_thermometers_on_event_id", using: :btree
  add_index "thermometers", ["uuid"], name: "index_thermometers_on_uuid", unique: true, using: :btree

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
    t.integer  "student_id"
  end

  add_index "timeline_user_messages", ["student_id"], name: "index_timeline_user_messages_on_student_id", using: :btree

  create_table "timelines", force: true do |t|
    t.datetime "start_at",   null: false
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timelines", ["event_id"], name: "index_timelines_on_event_id", using: :btree

  create_table "topics", force: true do |t|
    t.string   "description"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topics", ["event_id"], name: "index_topics_on_event_id", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
