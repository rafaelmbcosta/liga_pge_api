class AddPriceToDisputeMonth < ActiveRecord::Migration[5.0]
  def change
    add_column :dispute_months, :price, :float, null: false, default: 30.0
  end
end
