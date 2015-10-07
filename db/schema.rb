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

ActiveRecord::Schema.define(version: 20151007192841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "api_keys", force: true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["token"], name: "index_api_keys_on_token", unique: true, using: :btree
  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "attachments", force: true do |t|
    t.string   "original_filename", null: false
    t.string   "file_url",          null: false
    t.integer  "file_size",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.integer  "comment_id"
  end

  add_index "attachments", ["comment_id"], name: "index_attachments_on_comment_id", using: :btree
  add_index "attachments", ["profile_id"], name: "index_attachments_on_profile_id", using: :btree

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "profile_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["event_id"], name: "index_comments_on_event_id", using: :btree
  add_index "comments", ["profile_id"], name: "index_comments_on_profile_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "name"
    t.integer  "teacher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "class_name"
    t.string   "grade"
    t.string   "institution"
    t.string   "access_code"
    t.string   "abbreviation", limit: 10
  end

  add_index "courses", ["created_at"], name: "index_courses_on_created_at", using: :btree
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
    t.datetime "end_at"
    t.integer  "status",     default: 0
    t.string   "classroom"
  end

  add_index "events", ["course_id"], name: "index_events_on_course_id", using: :btree
  add_index "events", ["uuid"], name: "index_events_on_uuid", unique: true, using: :btree

  create_table "medias", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.string   "file_carrierwave"
    t.string   "status",            default: "available"
    t.datetime "released_at"
    t.json     "preview"
    t.integer  "mediable_id"
    t.string   "mediable_type"
    t.integer  "teacher_id"
    t.string   "thumbnail"
    t.string   "original_filename"
    t.string   "file_url"
    t.integer  "profile_id"
  end

  add_index "medias", ["mediable_id", "mediable_type"], name: "index_medias_on_mediable_id_and_mediable_type", using: :btree
  add_index "medias", ["profile_id"], name: "index_medias_on_profile_id", using: :btree
  add_index "medias", ["teacher_id"], name: "index_medias_on_teacher_id", using: :btree
  add_index "medias", ["uuid"], name: "index_medias_on_uuid", unique: true, using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "profile_id", null: false
    t.integer  "course_id",  null: false
    t.string   "role",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["course_id", "profile_id"], name: "index_memberships_on_course_id_and_profile_id", unique: true, using: :btree
  add_index "memberships", ["course_id"], name: "index_memberships_on_course_id", using: :btree
  add_index "memberships", ["profile_id"], name: "index_memberships_on_profile_id", using: :btree

  create_table "notifications", force: true do |t|
    t.string   "message"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["course_id"], name: "index_notifications_on_course_id", using: :btree

  create_table "profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_notifications", force: true do |t|
    t.integer  "author_id"
    t.integer  "profile_id"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.integer  "notification_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_notifications", ["author_id"], name: "index_system_notifications_on_author_id", using: :btree
  add_index "system_notifications", ["notifiable_id", "notifiable_type"], name: "index_system_notifications_on_notifiable_id_and_notifiable_type", using: :btree
  add_index "system_notifications", ["profile_id"], name: "index_system_notifications_on_profile_id", using: :btree

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

  create_table "topics", force: true do |t|
    t.text     "description"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "uuid"
    t.integer  "order"
    t.boolean  "done",        default: false
    t.integer  "media_id"
    t.boolean  "personal",    default: false
  end

  add_index "topics", ["event_id"], name: "index_topics_on_event_id", using: :btree
  add_index "topics", ["media_id"], name: "index_topics_on_media_id", using: :btree
  add_index "topics", ["uuid"], name: "index_topics_on_uuid", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                                null: false
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
    t.string   "facebook_uid"
    t.string   "avatar_url"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["facebook_uid"], name: "index_users_on_facebook_uid", using: :btree
  add_index "users", ["profile_id", "profile_type"], name: "index_users_on_profile_id_and_profile_type", using: :btree
  add_index "users", ["profile_id"], name: "index_users_on_profile_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uuid"], name: "index_users_on_uuid", unique: true, using: :btree

  create_table "weekly_schedules", force: true do |t|
    t.integer  "weekday"
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "classroom"
    t.uuid     "uuid"
  end

  add_index "weekly_schedules", ["course_id"], name: "index_weekly_schedules_on_course_id", using: :btree
  add_index "weekly_schedules", ["uuid"], name: "index_weekly_schedules_on_uuid", unique: true, using: :btree

end
