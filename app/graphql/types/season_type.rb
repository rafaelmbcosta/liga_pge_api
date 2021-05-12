module Types
  class SeasonType < Types::BaseObject
    field :id, ID, null: true
    field :year, Integer, null: false
    field :rounds, [RoundType], null: false do
      argument :finished, Boolean, required: false
    end
    field :disputes, [DisputeType], null: false

    # def self.visible?(context)
    #   !!context[:current_user]
    # end

    def rounds(**args)
      object.rounds.where(args)
    end
  end
end