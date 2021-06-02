class CreateRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :rounds do |t|
      t.integer :number, null: false
      t.boolean :golden, null: false, default: false
      t.references :season, foreign_key: true
      t.boolean :finished, null: false, default: false
      t.boolean :active, null: false, default: false
      t.boolean :market_closed, :boolean, null: false, default: false
      t.references :dispute_month, foreign_key: true
      t.timestamps
    end
  end
end
