# frozen_string_literal: true

class AddPositionToPredictions < ActiveRecord::Migration[8.0]
  def change
    add_column :predictions, :position, :integer
  end
end
