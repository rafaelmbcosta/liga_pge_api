module Types
  class QueryType < Types::BaseObject
    field :current_rules, RulesType, null: true, description:  "Current Rules"
    field :seasons, [SeasonType], null: false, description: "Season list"
    field :current_season, SeasonType, null: true, description: "Checks if there is an active Season"
    field :disputes, [DisputeType], null: false, resolver: Queries::Dispute::Disputes
    field :rounds, [RoundType], null: false, resolver: Queries::Round::Rounds
    field :current_user, UserType, null: true, resolver: Queries::CurrentUser
    field :logout, Boolean, null: false, description: "Logout"

    def logout
      Session.where(id: context[:session_id]).destroy_all
      true
    end

    def current_rules
      Rule.last
    end

    def seasons
      Season.all
    end

    def current_season
      Season.active
    end
  end
end
