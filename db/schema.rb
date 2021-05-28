# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_11_222621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "battles", id: :serial, force: :cascade do |t|
    t.integer "first_id"
    t.integer "second_id"
    t.integer "round_id"
    t.boolean "first_win"
    t.float "first_points", default: 0.0
    t.boolean "draw"
    t.boolean "second_win"
    t.float "second_points", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_battles_on_round_id"
  end

  create_table "currencies", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "round_id"
    t.float "difference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_currencies_on_round_id"
    t.index ["team_id"], name: "index_currencies_on_team_id"
  end

  create_table "dispute_months", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "season_id"
    t.boolean "finished", default: false, null: false
    t.string "details"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id"], name: "index_dispute_months_on_season_id"
  end

  create_table "month_activities", id: :serial, force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "dispute_month_id", null: false
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dispute_month_id"], name: "index_month_activities_on_dispute_month_id"
    t.index ["team_id"], name: "index_month_activities_on_team_id"
  end

  create_table "rounds", id: :serial, force: :cascade do |t|
    t.integer "number", null: false
    t.boolean "golden", default: false, null: false
    t.integer "season_id"
    t.boolean "finished", default: false, null: false
    t.boolean "active", default: false, null: false
    t.integer "dispute_month_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dispute_month_id"], name: "index_rounds_on_dispute_month_id"
    t.index ["season_id"], name: "index_rounds_on_season_id"
  end

  create_table "rules", force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scores", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.string "team_name"
    t.string "player_name"
    t.integer "round_id"
    t.float "partial_score", default: 0.0
    t.float "final_score", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_scores_on_round_id"
    t.index ["team_id"], name: "index_scores_on_team_id"
  end

  create_table "seasons", id: :serial, force: :cascade do |t|
    t.integer "year", null: false
    t.boolean "finished", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true, null: false
    t.string "slug"
    t.string "id_tag", null: false
    t.string "url_escudo_png"
    t.string "player_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "battles", "rounds"
  add_foreign_key "currencies", "rounds"
  add_foreign_key "currencies", "teams"
  add_foreign_key "month_activities", "dispute_months"
  add_foreign_key "month_activities", "teams"
  add_foreign_key "rounds", "dispute_months"
  add_foreign_key "rounds", "seasons"
  add_foreign_key "scores", "rounds"
  add_foreign_key "scores", "teams"
end
