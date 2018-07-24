class AddPayedToAward < ActiveRecord::Migration[5.0]
  def change
    add_column :awards, :payed, :boolean, default: false
  end
end
