class AddFinishedToDisputeMonth < ActiveRecord::Migration[5.0]
  def change
    add_column :dispute_months, :finished, :boolean, default: false
  end
end
