class CreateCurrencies < ActiveRecord::Migration[5.0]
  def change
    create_table :currencies do |t|
      t.float :value
      t.references :team, foreign_key: true
      t.references :round, foreign_key: true
      t.float :difference
      t.timestamps
    end
  end
end
