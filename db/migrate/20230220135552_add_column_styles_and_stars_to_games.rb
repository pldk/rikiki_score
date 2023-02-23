# frozen_string_literal: true

class AddColumnStylesAndStarsToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :style, :integer
    add_column :games, :stars, :boolean, default: false
  end
end
