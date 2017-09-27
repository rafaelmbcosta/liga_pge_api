class CreateMonthActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :month_activities do |t|
      t.references :team, foreign_key: true, null: false
      t.references :dispute_month, foreign_key: true, null: false
      t.boolean :active, null: false
      t.boolean :payed, null: false
      t.timestamps
    end
  end
end
