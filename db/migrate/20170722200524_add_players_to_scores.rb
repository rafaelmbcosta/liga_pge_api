class AddPlayersToScores < ActiveRecord::Migration[5.0]
  def change
    add_column :scores, :players, :integer, default: 12
  end
end
