# frozen_string_literal: true

class CreatePredictions < ActiveRecord::Migration[7.2]
  def change
    create_table :predictions do |t|
      t.integer :predicted_tricks
      t.integer :actual_tricks
      t.integer :score, default: 0
      t.boolean 'is_star', default: false
      t.boolean 'is_winner', default: false
      t.references :round, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
