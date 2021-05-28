class CreateDisputeMonths < ActiveRecord::Migration[5.0]
  def change
    create_table :dispute_months do |t|
      t.string :name, null: false
      t.references :season
      t.boolean :finished, null: false, default: false
      t.boolean :active, null: false, default: false
      t.string :details
      t.integer :order
      t.timestamps
    end
  end
end
