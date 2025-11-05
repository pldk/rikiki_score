# frozen_string_literal: true

class CreateScores < ActiveRecord::Migration[8.0]
  def change
    create_table :scores do |t|
      t.integer :value, default: 0, null: false
      t.integer :cumulative_value, default: 0, null: false

      t.references :prediction, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.references :round, null: false, foreign_key: true

      t.timestamps
    end
  end
end
