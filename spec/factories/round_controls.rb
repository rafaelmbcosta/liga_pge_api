FactoryBot.define do
  factory :round_control do
    generating_battles { false }
    battles_generated { false }
    battle_generated_date { "2019-05-10 10:42:56" }
    updating_scores { false }
    scores_updated { false }
    scores_updated_date { "2019-05-10 10:42:56" }
    round { nil }
    market_closed { false }
    updating_league { false }
    league_updated { false }
    league_updated_date { "2019-05-10 10:42:56" }
    updating_battle_scores { false }
    battle_scores_updated { false }
    battle_scores_update_date { "2019-05-10 10:42:56" }
    generating_currencies { false }
    currencies_generated { false }
    currencies_generated_date { "2019-05-10 10:42:56" }
  end
end
