class AddColumnPositionToGamePlayers < ActiveRecord::Migration[8.1]
  def change
    add_column :game_players, :position, :integer
  end
end
