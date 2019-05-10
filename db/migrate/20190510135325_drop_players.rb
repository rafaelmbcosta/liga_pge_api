class DropPlayers < ActiveRecord::Migration[5.0]
  def change
    remove_reference :teams, :player, index:true, foreign_key: true
    drop_table :players
    remove_reference :teams, :season, index:true, foreign_key: true
    add_column :teams, :player_name, :string
  end
end
