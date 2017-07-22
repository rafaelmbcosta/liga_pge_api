class CreateDisputeMonths < ActiveRecord::Migration[5.0]
  def change
    create_table :dispute_months do |t|
      t.string :name, null: false
      t.references :season
      t.string :details
      t.string :dispute_rounds
      t.timestamps
    end
  end
end
