module Types
  class RoundType < Types::BaseObject
    field :id, ID, null: true
    field :number, Integer, null: false
    field :market_closed, Boolean, null: false
    field :finished, Boolean, null: false
    field :golden, Boolean, null: false

    field :dispute, DisputeType, null: true
  end
end