class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.boolean :active, null: false, default: true
      # Dados do site
      t.string :slug
      t.string :url_escudo_png
      # adicionar aqui todos os dados que vem da API, e deixa pra na view atualizar o cadastro
      # correr na aula para chegar nos forms
      t.references :season, foreign_key: true
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
