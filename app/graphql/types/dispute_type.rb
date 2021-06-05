module Types
  class DisputeType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :order, Integer, null: true
    field :status, String, null: true
    field :season, SeasonType, null: false
    field :rounds, [RoundType], null: false

    def status
      return 'active' if object.active?
      return 'finished' if object.finished
      'created'
    end
  end
end