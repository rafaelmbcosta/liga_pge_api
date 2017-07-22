class CreateScores < ActiveRecord::Migration[5.0]
  def change
    create_table :scores do |t|
      t.references :team, foreign_key: true
      t.string :team_name
      t.string :player_name
      t.references :round, foreign_key: true
      t.float :partial_score, default: 0
      t.float :final_score, default: 0

      t.timestamps
    end
  end
end
