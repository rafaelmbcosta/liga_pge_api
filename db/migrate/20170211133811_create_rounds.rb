class CreateRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :rounds do |t|
      t.integer :number, null: false
      t.boolean :golden, null: false, default: false
      t.references :season, foreign_key: true
      t.date :market_open
      t.date :market_close
      t.boolean :finished, null: false, default: false

      t.timestamps
    end
  end
end
