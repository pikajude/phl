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

ActiveRecord::Schema.define(version: 20130409195721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "boards", force: true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.integer  "moderator_id"
    t.integer  "team_id"
    t.integer  "board_id"
    t.boolean  "is_group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dashboard_boxes", force: true do |t|
    t.string   "title"
    t.boolean  "deletable"
    t.integer  "player_id"
    t.float    "relative_size", default: 0.0, null: false
    t.string   "template_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "draft_picks", force: true do |t|
    t.integer  "order",      limit: 2
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "draft_id"
  end

  create_table "drafts", force: true do |t|
    t.integer  "division",   limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "season_id"
  end

  create_table "forum_threads", force: true do |t|
    t.string   "title"
    t.boolean  "sticky"
    t.boolean  "locked"
    t.boolean  "announce"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "season_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "played_on",           default: '2013-04-04 02:34:06', null: false
    t.integer  "week"
    t.integer  "day"
    t.integer  "substitution_count",  default: 0,                     null: false
    t.boolean  "overtime",            default: false
    t.boolean  "finished",            default: false,                 null: false
    t.boolean  "reported",            default: false,                 null: false
    t.integer  "current_activity_id"
    t.datetime "current_activity"
    t.integer  "last_activity_id"
    t.datetime "last_activity"
    t.integer  "home_score",          default: 0,                     null: false
    t.integer  "away_score",          default: 0,                     null: false
  end

  create_table "goals", force: true do |t|
    t.integer  "game_id"
    t.integer  "scorer_id"
    t.integer  "first_assist_id"
    t.integer  "second_assist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
    t.integer  "scored_against"
    t.integer  "time",             default: 0
    t.integer  "half",             default: 1, null: false
  end

  create_table "pick_proposals", force: true do |t|
    t.integer  "pick_id"
    t.integer  "trade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player_proposals", force: true do |t|
    t.integer  "player_id"
    t.integer  "trade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "username",               limit: 16
    t.integer  "team_id"
    t.string   "signature",              limit: 5000
    t.string   "title",                  limit: 32
    t.integer  "rep"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "email",                               default: "",  null: false
    t.string   "encrypted_password",     limit: 128,  default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "points",                              default: 0
    t.integer  "goals",                               default: 0
    t.integer  "assists",                             default: 0
    t.integer  "goals_against",                       default: 0
    t.float    "gaa",                                 default: 0.0
    t.float    "ppg",                                 default: 0.0
    t.float    "minutes_played",                      default: 0.0
  end

  add_index "players", ["confirmation_token"], name: "index_players_on_confirmation_token", unique: true
  add_index "players", ["email"], name: "index_players_on_email", unique: true
  add_index "players", ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true
  add_index "players", ["unlock_token"], name: "index_players_on_unlock_token", unique: true

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "player_id"
    t.integer  "reply_to"
    t.integer  "forum_thread_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scheduled_attendances", force: true do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "season_number"
  end

  create_table "substitutions", force: true do |t|
    t.integer  "game_id"
    t.integer  "player_on_id"
    t.integer  "player_off_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "on_time"
    t.integer  "off_time"
    t.integer  "team_id"
  end

  create_table "teams", force: true do |t|
    t.string   "name",              limit: 64,                    null: false
    t.string   "short_name",        limit: 12,                    null: false
    t.boolean  "d1",                           default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "color",                        default: 16777215
    t.integer  "season_id"
    t.integer  "points",                       default: 0,        null: false
    t.integer  "seed",                                            null: false
    t.integer  "wins",                         default: 0,        null: false
    t.integer  "losses",                       default: 0,        null: false
    t.integer  "ties",                         default: 0,        null: false
    t.integer  "overtime_wins",                default: 0,        null: false
    t.integer  "overtime_losses",              default: 0,        null: false
    t.string   "slug"
  end

  create_table "trades", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
    t.integer  "opposing_trade_id"
  end

end
