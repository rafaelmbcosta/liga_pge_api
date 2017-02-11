class CreateBattles < ActiveRecord::Migration[5.0]
  def change
    create_table :battles do |t|
      t.integer :first_id, null: false
      t.string :second_id, null: false
      t.references :round, foreign_key: true
      t.boolean :first_win
      t.float :first_points, default: 0
      t.boolean :draw
      t.boolean :second_win
      t.float :second_points, default: 0

      t.timestamps
    end
  end
end
