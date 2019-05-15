class CreateFlowControls < ActiveRecord::Migration[5.0]
  def change
    create_table :flow_controls do |t|
      t.integer :message_type
      t.text :message
      t.datetime :date

      t.timestamps
    end
  end
end
