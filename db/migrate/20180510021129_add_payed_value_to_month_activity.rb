class AddPayedValueToMonthActivity < ActiveRecord::Migration[5.0]
  def change
    add_column :month_activities, :payed_value, :float, default: 0
  end
end
