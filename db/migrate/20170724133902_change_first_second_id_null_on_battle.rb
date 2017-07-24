class ChangeFirstSecondIdNullOnBattle < ActiveRecord::Migration[5.0]
  def change
    remove_column :battles, :first_id
    remove_column :battles, :second_id
    add_column :battles, :second_id, :integer
    add_column :battles, :first_id, :integer
  end
end
