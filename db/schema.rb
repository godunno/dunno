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

ActiveRecord::Schema.define(version: 20141124172250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "answers", force: true do |t|
    t.integer  "student_id"
    t.integer  "option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["option_id"], name: "index_answers_on_option_id", using: :btree
  add_index "answers", ["student_id"], name: "index_answers_on_student_id", using: :btree

  create_table "api_keys", force: true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["token"], name: "index_api_keys_on_token", unique: true, using: :btree
  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "artifacts", force: true do |t|
    t.integer  "teacher_id"
    t.integer  "heir_id"
    t.string   "heir_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timeline_id"
  end

  add_index "artifacts", ["heir_id", "heir_type"], name: "index_artifacts_on_heir_id_and_heir_type", unique: true, using: :btree
  add_index "artifacts", ["teacher_id"], name: "index_artifacts_on_teacher_id", using: :btree
  add_index "artifacts", ["timeline_id"], name: "index_artifacts_on_timeline_id", using: :btree

  create_table "attendances", force: true do |t|
    t.integer  "student_id"
    t.integer  "event_id"
    t.boolean  "validated",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendances", ["event_id"], name: "index_attendances_on_event_id", using: :btree
  add_index "attendances", ["student_id"], name: "index_attendances_on_student_id", using: :btree

  create_table "beacons", force: true do |t|
    t.uuid     "uuid"
    t.integer  "major",      limit: 8
    t.integer  "minor",      limit: 8
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "beacons", ["uuid"], name: "index_beacons_on_uuid", unique: true, using: :btree

  create_table "courses", force: true do |t|
    t.string   "name"
    t.integer  "teacher_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "class_name"
    t.string   "grade"
    t.string   "institution"
    t.string   "access_code"
  end

  add_index "courses", ["organization_id"], name: "index_courses_on_organization_id", using: :btree
  add_index "courses", ["teacher_id"], name: "index_courses_on_teacher_id", using: :btree
  add_index "courses", ["uuid"], name: "index_courses_on_uuid", unique: true, using: :btree

  create_table "courses_students", id: false, force: true do |t|
    t.integer "course_id"
    t.integer "student_id"
  end

  add_index "courses_students", ["course_id", "student_id"], name: "index_courses_students_on_course_id_and_student_id", unique: true, using: :btree
  add_index "courses_students", ["course_id"], name: "index_courses_students_on_course_id", using: :btree
  add_index "courses_students", ["student_id"], name: "index_courses_students_on_student_id", using: :btree

  create_table "events", force: true do |t|
    t.datetime "start_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "course_id"
    t.datetime "closed_at"
    t.datetime "opened_at"
    t.integer  "beacon_id"
    t.datetime "end_at"
    t.integer  "status",     default: 0
  end

  add_index "events", ["beacon_id"], name: "index_events_on_beacon_id", using: :btree
  add_index "events", ["course_id"], name: "index_events_on_course_id", using: :btree
  add_index "events", ["uuid"], name: "index_events_on_uuid", unique: true, using: :btree

  create_table "medias", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "category"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.string   "file"
    t.string   "status",        default: "available"
    t.datetime "released_at"
    t.json     "preview"
    t.integer  "mediable_id"
    t.string   "mediable_type"
    t.integer  "teacher_id"
    t.string   "thumbnail"
  end

  add_index "medias", ["mediable_id", "mediable_type"], name: "index_medias_on_mediable_id_and_mediable_type", using: :btree
  add_index "medias", ["teacher_id"], name: "index_medias_on_teacher_id", using: :btree
  add_index "medias", ["uuid"], name: "index_medias_on_uuid", unique: true, using: :btree

  create_table "notifications", force: true do |t|
    t.string  "message"
    t.integer "course_id"
  end

  add_index "notifications", ["course_id"], name: "index_notifications_on_course_id", using: :btree

  create_table "options", force: true do |t|
    t.string   "content"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.boolean  "correct"
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

  create_table "personal_notes", force: true do |t|
    t.string   "description"
    t.boolean  "done"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "uuid"
    t.integer  "order"
  end

  add_index "personal_notes", ["event_id"], name: "index_personal_notes_on_event_id", using: :btree
  add_index "personal_notes", ["uuid"], name: "index_personal_notes_on_uuid", unique: true, using: :btree

  create_table "polls", force: true do |t|
    t.string   "content"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",      default: "available"
    t.string   "uuid"
    t.datetime "released_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "teachers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "timeline_messages", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.uuid     "uuid"
  end

  add_index "timeline_messages", ["student_id"], name: "index_timeline_messages_on_student_id", using: :btree
  add_index "timeline_messages", ["uuid"], name: "index_timeline_messages_on_uuid", unique: true, using: :btree

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
    t.uuid     "uuid"
    t.integer  "order"
    t.boolean  "done"
  end

  add_index "topics", ["event_id"], name: "index_topics_on_event_id", using: :btree
  add_index "topics", ["uuid"], name: "index_topics_on_uuid", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                                null: false
    t.string   "phone_number",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "authentication_token"
    t.integer  "profile_id"
    t.string   "profile_type"
    t.uuid     "uuid"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["profile_id", "profile_type"], name: "index_users_on_profile_id_and_profile_type", using: :btree
  add_index "users", ["profile_id"], name: "index_users_on_profile_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree

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

  create_table "weekly_schedules", force: true do |t|
    t.integer  "weekday"
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "classroom"
  end

  add_index "weekly_schedules", ["course_id"], name: "index_weekly_schedules_on_course_id", using: :btree

end
