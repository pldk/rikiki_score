# frozen_string_literal: true

class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds do |t|
      t.integer :length
      t.string :phase
      t.integer :position
      t.references :game, null: false, foreign_key: true
      t.boolean 'has_trump', default: true

      t.timestamps
    end
  end
end
