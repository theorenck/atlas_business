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

ActiveRecord::Schema.define(version: 20141218122652) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "api_servers", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dashboards", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "indicators", force: true do |t|
    t.string   "unity"
    t.string   "name"
    t.string   "description"
    t.integer  "query_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "indicators", ["query_id"], name: "index_indicators_on_query_id", using: :btree

  create_table "parameters", force: true do |t|
    t.string   "name"
    t.string   "data_type"
    t.string   "default_value"
    t.integer  "query_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parameters", ["query_id"], name: "index_parameters_on_query_id", using: :btree

  create_table "permissions", force: true do |t|
    t.integer  "dashboard_id"
    t.integer  "api_server_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["api_server_id"], name: "index_permissions_on_api_server_id", using: :btree
  add_index "permissions", ["dashboard_id"], name: "index_permissions_on_dashboard_id", using: :btree
  add_index "permissions", ["user_id"], name: "index_permissions_on_user_id", using: :btree

  create_table "queries", force: true do |t|
    t.string   "type"
    t.text     "statement"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "password"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widget_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", force: true do |t|
    t.string   "color"
    t.integer  "position"
    t.integer  "size"
    t.string   "name"
    t.string   "description"
    t.integer  "dashboard_id"
    t.integer  "indicator_id"
    t.integer  "widget_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "widgets", ["dashboard_id"], name: "index_widgets_on_dashboard_id", using: :btree
  add_index "widgets", ["indicator_id"], name: "index_widgets_on_indicator_id", using: :btree
  add_index "widgets", ["widget_type_id"], name: "index_widgets_on_widget_type_id", using: :btree

end
