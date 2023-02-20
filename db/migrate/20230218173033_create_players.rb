# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :description
      t.integer :rank

      t.timestamps
    end
  end
end
