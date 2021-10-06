module Types
  class DisputeScoreType < Types::BaseObject
    field :team, TeamType, null: false
    field :score, Float, null: false
    field :scores, [ScoreType], null: false
  end
end
