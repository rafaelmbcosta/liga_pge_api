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

ActiveRecord::Schema.define(version: 20190511191202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "awards", force: :cascade do |t|
    t.integer  "award_type",                       null: false
    t.integer  "dispute_month_id"
    t.integer  "team_id",                          null: false
    t.integer  "position"
    t.integer  "season_id"
    t.float    "prize",                            null: false
    t.integer  "round_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "payed",            default: false
    t.index ["dispute_month_id"], name: "index_awards_on_dispute_month_id", using: :btree
    t.index ["round_id"], name: "index_awards_on_round_id", using: :btree
    t.index ["season_id"], name: "index_awards_on_season_id", using: :btree
    t.index ["team_id"], name: "index_awards_on_team_id", using: :btree
  end

  create_table "battles", force: :cascade do |t|
    t.integer  "round_id"
    t.boolean  "first_win"
    t.float    "first_points",  default: 0.0
    t.boolean  "draw"
    t.boolean  "second_win"
    t.float    "second_points", default: 0.0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "second_id"
    t.integer  "first_id"
    t.index ["round_id"], name: "index_battles_on_round_id", using: :btree
  end

  create_table "currencies", force: :cascade do |t|
    t.float    "value"
    t.integer  "team_id"
    t.integer  "round_id"
    t.float    "difference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_currencies_on_round_id", using: :btree
    t.index ["team_id"], name: "index_currencies_on_team_id", using: :btree
  end

  create_table "dispute_months", force: :cascade do |t|
    t.string   "name",                           null: false
    t.integer  "season_id"
    t.string   "details"
    t.string   "dispute_rounds"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.float    "price",          default: 30.0,  null: false
    t.boolean  "finished",       default: false
    t.index ["season_id"], name: "index_dispute_months_on_season_id", using: :btree
  end

  create_table "flow_controls", force: :cascade do |t|
    t.integer  "message_type"
    t.text     "message"
    t.datetime "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "month_activities", force: :cascade do |t|
    t.integer  "team_id",                        null: false
    t.integer  "dispute_month_id",               null: false
    t.boolean  "active",                         null: false
    t.boolean  "payed",                          null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.float    "payed_value",      default: 0.0
    t.index ["dispute_month_id"], name: "index_month_activities_on_dispute_month_id", using: :btree
    t.index ["team_id"], name: "index_month_activities_on_team_id", using: :btree
  end

  create_table "round_controls", force: :cascade do |t|
    t.boolean  "generating_battles",        default: false, null: false
    t.boolean  "battles_generated",         default: false, null: false
    t.datetime "battle_generated_date"
    t.boolean  "updating_scores",           default: false, null: false
    t.boolean  "scores_updated",            default: false, null: false
    t.datetime "scores_updated_date"
    t.integer  "round_id"
    t.boolean  "market_closed",             default: false, null: false
    t.boolean  "updating_league",           default: false, null: false
    t.boolean  "league_updated",            default: false, null: false
    t.datetime "league_updated_date"
    t.boolean  "updating_battle_scores",    default: false, null: false
    t.boolean  "battle_scores_updated",     default: false, null: false
    t.datetime "battle_scores_update_date"
    t.boolean  "generating_currencies",     default: false, null: false
    t.boolean  "currencies_generated",      default: false, null: false
    t.datetime "currencies_generated_date"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["round_id"], name: "index_round_controls_on_round_id", using: :btree
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "number",                           null: false
    t.boolean  "golden",           default: false, null: false
    t.integer  "season_id"
    t.date     "market_open"
    t.datetime "market_close"
    t.boolean  "finished",         default: false, null: false
    t.integer  "dispute_month_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["dispute_month_id"], name: "index_rounds_on_dispute_month_id", using: :btree
    t.index ["season_id"], name: "index_rounds_on_season_id", using: :btree
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "team_name"
    t.string   "player_name"
    t.integer  "round_id"
    t.float    "partial_score", default: 0.0
    t.float    "final_score",   default: 0.0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "players",       default: 12
    t.index ["round_id"], name: "index_scores_on_round_id", using: :btree
    t.index ["team_id"], name: "index_scores_on_team_id", using: :btree
  end

  create_table "seasons", force: :cascade do |t|
    t.integer  "year",                          null: false
    t.boolean  "finished",      default: false, null: false
    t.string   "golden_rounds"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",                          null: false
    t.boolean  "active",         default: true, null: false
    t.string   "slug"
    t.string   "url_escudo_png"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "id_tag"
    t.string   "player_name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "awards", "dispute_months"
  add_foreign_key "awards", "rounds"
  add_foreign_key "awards", "seasons"
  add_foreign_key "awards", "teams"
  add_foreign_key "battles", "rounds"
  add_foreign_key "currencies", "rounds"
  add_foreign_key "currencies", "teams"
  add_foreign_key "month_activities", "dispute_months"
  add_foreign_key "month_activities", "teams"
  add_foreign_key "round_controls", "rounds"
  add_foreign_key "rounds", "dispute_months"
  add_foreign_key "rounds", "seasons"
  add_foreign_key "scores", "rounds"
  add_foreign_key "scores", "teams"
end
