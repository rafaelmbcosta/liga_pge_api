class CreateSeasons < ActiveRecord::Migration[5.0]
  def change
    create_table :seasons do |t|
      t.integer :year, null: false
      t.boolean :finished, null: false, default: false
      t.string :golden_rounds
      t.timestamps
    end
  end
end
