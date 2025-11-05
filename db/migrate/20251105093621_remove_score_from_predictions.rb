# frozen_string_literal: true

class RemoveScoreFromPredictions < ActiveRecord::Migration[8.0]
  def change
    remove_column :predictions, :score, :integer
  end
end
