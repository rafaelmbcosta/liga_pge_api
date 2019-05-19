class AddScoresCreatedToRoundControl < ActiveRecord::Migration[5.0]
  def change
    add_column :round_controls, :scores_created, :boolean, null: false, default: false
    add_column :round_controls, :creating_scores, :boolean, null: false, default: false
  end
end
