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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120717213924) do

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "project_tasks", :force => true do |t|
    t.integer  "task_id"
    t.integer  "project_id"
    t.string   "short_url"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "completed",  :default => false
    t.integer  "clicks",     :default => 0
  end

  create_table "projects", :force => true do |t|
    t.string   "dc_id"
    t.string   "dc_url"
    t.integer  "goal_cents"
    t.integer  "percent_funded"
    t.integer  "cost_to_complete_cents"
    t.string   "image_url"
    t.string   "teacher_name"
    t.string   "title"
    t.string   "school"
    t.date     "expiration_date"
    t.string   "fund_url"
    t.string   "city"
    t.string   "state"
    t.string   "description"
    t.string   "stage"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.date     "start_date"
    t.string   "slug"
    t.integer  "user_id"
  end

  add_index "projects", ["slug"], :name => "index_projects_on_slug"

  create_table "tasks", :force => true do |t|
    t.string   "medium"
    t.string   "stage"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "description"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
