class CreateDisputeMonths < ActiveRecord::Migration[5.0]
  def change
    create_table :dispute_months do |t|
      t.integer :number
      t.string :details

      t.timestamps
    end
  end
end
