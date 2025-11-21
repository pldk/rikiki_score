class RemoveColumnPositionFromPredictions < ActiveRecord::Migration[8.1]
  def change
    remove_column :predictions, :position, :integer
  end
end
