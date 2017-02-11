class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.boolean :active, null: false, default: true
      t.references :season, foreign_key: true
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
