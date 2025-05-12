# frozen_string_literal: true

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

ActiveRecord::Schema[7.2].define(version: 20_250_512_125_936) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'game_players', force: :cascade do |t|
    t.bigint 'game_id', null: false
    t.bigint 'player_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['game_id'], name: 'index_game_players_on_game_id'
    t.index ['player_id'], name: 'index_game_players_on_player_id'
  end

  create_table 'games', force: :cascade do |t|
    t.integer 'status', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'style'
    t.boolean 'stars', default: false
  end

  create_table 'players', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.integer 'rank'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'predictions', force: :cascade do |t|
    t.integer 'predicted_tricks'
    t.integer 'actual_tricks'
    t.integer 'score', default: 0
    t.boolean 'is_star', default: false
    t.boolean 'is_winner', default: false
    t.bigint 'round_id', null: false
    t.bigint 'player_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['player_id'], name: 'index_predictions_on_player_id'
    t.index ['round_id'], name: 'index_predictions_on_round_id'
  end

  create_table 'rounds', force: :cascade do |t|
    t.integer 'length'
    t.integer 'phase', default: 0
    t.integer 'position'
    t.bigint 'game_id', null: false
    t.boolean 'has_trump', default: true
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['game_id'], name: 'index_rounds_on_game_id'
  end

  add_foreign_key 'game_players', 'games'
  add_foreign_key 'game_players', 'players'
  add_foreign_key 'predictions', 'players'
  add_foreign_key 'predictions', 'rounds'
  add_foreign_key 'rounds', 'games'
end
