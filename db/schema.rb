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

ActiveRecord::Schema.define(version: 20140816030214) do

  create_table "contestants", force: true do |t|
    t.string  "name"
    t.integer "show_id"
    t.integer "age"
    t.string  "gender"
    t.string  "occupation"
    t.text    "description"
    t.string  "status_on_show"
    t.boolean "present",        default: true
  end

  create_table "contestants_rosters", force: true do |t|
    t.integer "contestant_id"
    t.integer "roster_id"
  end

  create_table "episodes", force: true do |t|
    t.integer "show_id"
  end

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.integer  "commissioner_id"
    t.integer  "show_id"
    t.boolean  "public_access",   default: true
    t.string   "draft_type"
    t.integer  "scoring_system"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "league_key"
    t.string   "league_password"
  end

  create_table "leagues_users", id: false, force: true do |t|
    t.integer "league_id"
    t.integer "user_id"
  end

  create_table "rosters", force: true do |t|
    t.integer  "user_id"
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", force: true do |t|
    t.integer "league_id"
    t.integer "episode_id"
  end

  create_table "shows", force: true do |t|
    t.string   "name"
    t.datetime "premiere_date"
    t.datetime "draft_close_date"
    t.string   "country_origin"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "password_digest"
    t.string   "avatar"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
