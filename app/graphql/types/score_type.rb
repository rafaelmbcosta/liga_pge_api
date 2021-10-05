module Types
  class ScoreType < Types::BaseObject
    field :id, ID, null: true
    field :team, TeamType, null: true
    field :team_name, String, null: true
    field :player_name, String, null: true
    field :round, RoundType, null: true
    field :partial_score, Float, null: true
    field :final_score, Float, null: true
  end
end