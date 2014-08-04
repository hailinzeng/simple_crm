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

ActiveRecord::Schema.define(version: 6) do

  create_table "cities", force: true do |t|
    t.string  "name"
    t.integer "city_id"
    t.integer "province_id"
  end

  create_table "communications", force: true do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.integer  "channel"
    t.string   "comment"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "mobile"
    t.string   "telephone"
    t.date     "birthday"
    t.string   "company"
    t.string   "career"
    t.string   "department"
    t.string   "market"
    t.string   "scale"
    t.string   "address"
    t.string   "qq"
    t.string   "weixin"
    t.integer  "status"
    t.string   "comment"
    t.integer  "city_id"
    t.integer  "province_id"
    t.integer  "user_id"
    t.integer  "publish_cars_count"
    t.integer  "collect_cars_count"
    t.datetime "last_login_at"
    t.datetime "last_publish_at"
    t.datetime "last_collect_at"
    t.datetime "import_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", force: true do |t|
    t.string   "key"
    t.string   "name"
    t.string   "url"
    t.text     "options"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus_roles", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "menu_id"
  end

  create_table "provinces", force: true do |t|
    t.string  "name"
    t.integer "province_id"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "label"
    t.text     "permission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "name"
    t.string   "email"
    t.string   "mobile"
    t.boolean  "active",           default: false
    t.string   "salt"
    t.string   "crypted_password"
    t.integer  "role_id"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
