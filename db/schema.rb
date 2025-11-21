# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_20_102612) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "game_players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "game_id", null: false
    t.bigint "player_id", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_players_on_game_id"
    t.index ["player_id"], name: "index_game_players_on_player_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "stars", default: false
    t.integer "status", default: 0
    t.integer "style"
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.integer "rank"
    t.datetime "updated_at", null: false
  end

  create_table "predictions", force: :cascade do |t|
    t.integer "actual_tricks"
    t.datetime "created_at", null: false
    t.boolean "is_star", default: false
    t.boolean "is_winner", default: false
    t.bigint "player_id", null: false
    t.integer "predicted_tricks"
    t.bigint "round_id", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_predictions_on_player_id"
    t.index ["round_id"], name: "index_predictions_on_round_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "game_id", null: false
    t.boolean "has_trump", default: true
    t.integer "length"
    t.integer "phase"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_rounds_on_game_id"
  end

  create_table "scores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "cumulative_value", default: 0, null: false
    t.bigint "player_id", null: false
    t.bigint "prediction_id", null: false
    t.bigint "round_id", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 0, null: false
    t.index ["player_id"], name: "index_scores_on_player_id"
    t.index ["prediction_id"], name: "index_scores_on_prediction_id"
    t.index ["round_id"], name: "index_scores_on_round_id"
  end

  add_foreign_key "game_players", "games"
  add_foreign_key "game_players", "players"
  add_foreign_key "predictions", "players"
  add_foreign_key "predictions", "rounds"
  add_foreign_key "rounds", "games"
  add_foreign_key "scores", "players"
  add_foreign_key "scores", "predictions"
  add_foreign_key "scores", "rounds"
end
