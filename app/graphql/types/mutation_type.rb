module Types
  class MutationType < Types::BaseObject
    field :login, String, null: true, mutation: Mutations::Login
    field :create_season, SeasonType, mutation: Mutations::Season::Create
    field :save_rules, RulesType, null: false, mutation: Mutations::Rules::Create
    field :create_dispute, DisputeType, mutation: Mutations::Dispute::Create
  end
end
