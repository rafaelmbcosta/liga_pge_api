class CreateRoundControls < ActiveRecord::Migration[5.0]
  def change
    create_table :round_controls do |t|
      t.boolean    :generating_battles, null:false, default: false
      t.boolean    :battles_generated, null:false, default: false
      t.datetime   :battle_generated_date
      t.boolean    :updating_scores, null:false, default: false
      t.boolean    :scores_updated, null:false, default: false
      t.datetime   :scores_updated_date
      t.references :round, foreign_key: true
      t.boolean    :market_closed, null:false, default: false
      t.boolean    :updating_league, null:false, default: false
      t.boolean    :league_updated, null:false, default: false
      t.datetime   :league_updated_date
      t.boolean    :updating_battle_scores, null:false, default: false
      t.boolean    :battle_scores_updated, null:false, default: false
      t.datetime   :battle_scores_update_date
      t.boolean    :generating_currencies, null:false, default: false
      t.boolean    :currencies_generated, null:false, default: false
      t.datetime   :currencies_generated_date

      t.timestamps
    end
  end
end
