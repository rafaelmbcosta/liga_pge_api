module Types
  class RoundType < Types::BaseObject
    field :id, ID, null: true
    field :number, Integer, null: false
    field :market_closed, Boolean, null: false
    field :finished, Boolean, null: false
    field :golden, Boolean, null: false
    field :status, String, null: true
    field :dispute, DisputeType, null: true
  end

  def status
    object.status
  end
end