module Types
  class QueryType < Types::BaseObject
    field :seasons, [SeasonType], null: false, description: "Season list"

    def seasons
      Season.all
    end

    field :current_season, SeasonType, null: true, description: "Checks if there is an active Season"

    def current_season
      Season.active
    end

    field :current_user, UserType, null: true, description: "Currently logged user", camelize: false

    def current_user
      context[:current_user]
    end

    field :disputes, [DisputeType], null: false, description: "Dispute months"

    def disputes
      Dispute.all
    end

    field :season_updated, subscription: Subscriptions::SeasonUpdated

    field :rounds, [RoundType], null: false, description: "Round pool" do
      argument :number, Integer, required: false
      argument :dispute, ID, required: false
    end

    def rounds(**args)
      params = { season: Season.active }.merge(args)
      Round.where(params)
    end
  end
end
