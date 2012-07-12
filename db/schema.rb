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

ActiveRecord::Schema.define(:version => 20120711200834) do

  create_table "project_tasks", :force => true do |t|
    t.integer  "task_id"
    t.integer  "project_id"
    t.boolean  "completed"
    t.integer  "clicks"
    t.string   "short_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.boolean  "on_track"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "tasks", :force => true do |t|
    t.string   "type"
    t.string   "stage"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
