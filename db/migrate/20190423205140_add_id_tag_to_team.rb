class AddIdTagToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :id_tag, :string
  end
end
