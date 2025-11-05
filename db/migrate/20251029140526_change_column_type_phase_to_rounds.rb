# frozen_string_literal: true

class ChangeColumnTypePhaseToRounds < ActiveRecord::Migration[8.0]
  def up
    add_column :rounds, :phase_tmp, :integer

    execute <<~SQL
      UPDATE rounds SET phase_tmp = CASE
        WHEN phase = '0' THEN 0
        WHEN phase = '1' THEN 1
        WHEN phase = 'up' THEN 0
        WHEN phase = 'down' THEN 1
        ELSE NULL
      END
    SQL

    remove_column :rounds, :phase
    rename_column :rounds, :phase_tmp, :phase
  end

  def down
    add_column :rounds, :phase_tmp, :string
  end
end
