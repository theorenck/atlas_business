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

ActiveRecord::Schema.define(version: 20150106184803) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "aggregations_sources", force: true do |t|
    t.integer  "aggregation_id"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aggregations_sources", ["aggregation_id", "source_id"], name: "index_aggregations_sources_on_aggregation_id_and_source_id", unique: true, using: :btree

  create_table "dashboards", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_source_servers", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.boolean  "alive"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "executions", force: true do |t|
    t.integer  "aggregation_id"
    t.integer  "function_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "functions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "indicators", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "unity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "indicators", ["source_id", "source_type"], name: "index_indicators_on_source_id_and_source_type", using: :btree
  add_index "indicators", ["unity_id"], name: "index_indicators_on_unity_id", using: :btree

  create_table "parameters", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "value"
    t.string   "datatype"
    t.boolean  "evaluated"
    t.integer  "parameterizable_id"
    t.string   "parameterizable_type"
    t.integer  "function_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parameters", ["function_id"], name: "index_parameters_on_function_id", using: :btree
  add_index "parameters", ["parameterizable_id", "parameterizable_type"], name: "index_parameters_on_parameterizable_id_and_parameterizable_type", using: :btree

  create_table "permissions", force: true do |t|
    t.integer  "dashboard_id"
    t.integer  "data_source_server_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["dashboard_id"], name: "index_permissions_on_dashboard_id", using: :btree
  add_index "permissions", ["data_source_server_id"], name: "index_permissions_on_data_source_server_id", using: :btree
  add_index "permissions", ["user_id"], name: "index_permissions_on_user_id", using: :btree

  create_table "sources", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "statement"
    t.integer  "limit"
    t.integer  "offset"
    t.string   "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unities", force: true do |t|
    t.string   "name"
    t.string   "symbol"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "password"
    t.string   "token"
    t.boolean  "admin"
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
    t.boolean  "customized",     default: false
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
