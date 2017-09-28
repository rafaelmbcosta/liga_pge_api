class CreateAwards < ActiveRecord::Migration[5.0]
  def change
    create_table :awards do |t|
      t.integer :award_type, null: false
      t.references :dispute_month, foreign_key: true
      t.references :team, foreign_key: true, null: false
      t.integer :position
      t.references :season, foreign_key: true
      t.float :prize, null: false

      t.timestamps
    end
  end
end
