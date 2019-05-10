class ChangeMarketClosedToDateTime < ActiveRecord::Migration[5.0]
  def change
    change_column :rounds, :market_close, :datetime
  end
end
