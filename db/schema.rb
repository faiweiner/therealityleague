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

ActiveRecord::Schema.define(version: 20150105113557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contestants", force: true do |t|
    t.string   "name"
    t.integer  "season_id"
    t.string   "image"
    t.integer  "age"
    t.string   "gender"
    t.string   "occupation"
    t.text     "description"
    t.string   "status_on_show"
    t.string   "source"
    t.boolean  "present",        default: true
    t.integer  "episode_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contestants_rosters", id: false, force: true do |t|
    t.integer "contestant_id"
    t.integer "roster_id"
  end

  create_table "contestants_rounds", id: false, force: true do |t|
    t.integer "contestant_id"
    t.integer "round_id"
  end

  create_table "episodes", force: true do |t|
    t.integer  "season_id"
    t.datetime "air_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.integer  "contestant_id"
    t.integer  "episode_id"
    t.integer  "scheme_id"
    t.integer  "points_earned"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.integer  "commissioner_id"
    t.integer  "season_id"
    t.boolean  "public_access",   default: true
    t.string   "type"
    t.integer  "participant_cap"
    t.integer  "draft_limit"
    t.datetime "draft_deadline"
    t.string   "draft_order"
    t.integer  "scoring_system"
    t.string   "league_key"
    t.string   "league_password"
    t.boolean  "active",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues_schemes", id: false, force: true do |t|
    t.integer "league_id"
    t.integer "scheme_id"
  end

  create_table "leagues_users", id: false, force: true do |t|
    t.integer "league_id"
    t.integer "user_id"
  end

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rosters", force: true do |t|
    t.integer  "user_id"
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", force: true do |t|
    t.integer  "user_id"
    t.integer  "league_id"
    t.integer  "episode_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schemes", force: true do |t|
    t.string   "type"
    t.integer  "show_id"
    t.string   "description"
    t.integer  "points_asgn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: true do |t|
    t.string   "name"
    t.integer  "number"
    t.integer  "show_id"
    t.datetime "premiere_date"
    t.datetime "finale_date"
    t.string   "country_origin"
    t.string   "type"
    t.text     "description"
    t.integer  "episode_count"
    t.string   "image"
    t.boolean  "published",      default: false
    t.boolean  "expired",        default: false
    t.string   "website"
    t.string   "network"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shows", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string  "name"
    t.integer "season_id"
    t.integer "contestant_id"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "password_digest"
    t.string   "avatar"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.boolean  "admin",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
