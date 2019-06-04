class RemoveValueFromCurrency < ActiveRecord::Migration[5.2]
  def change
    remove_column :currencies, :value
  end
end
