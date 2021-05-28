class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.boolean :active, null: false, default: true
      # Dados do site
      t.string :slug
      t.string :id_tag, null: false
      t.string :url_escudo_png
      t.string :player_name
      t.timestamps
    end
  end
end
