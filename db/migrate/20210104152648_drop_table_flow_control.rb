class DropTableFlowControl < ActiveRecord::Migration[5.2]
  def change
    drop_table :flow_controls
  end
end
