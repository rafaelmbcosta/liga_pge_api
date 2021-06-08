module Types
  class MutationType < Types::BaseObject
    field :login, String, null: true, mutation: Mutations::Login
    field :create_season, SeasonType, mutation: Mutations::Season::Create
    field :save_rules, RulesType, null: false, mutation: Mutations::Rules::Create
    field :create_dispute, DisputeType, mutation: Mutations::Dispute::Create
    field :edit_dispute, DisputeType, mutation: Mutations::Dispute::Edit
    field :delete_dispute, DisputeType, mutation: Mutations::Dispute::Delete
    field :create_team_by_id, TeamType, null: false, mutation: Mutations::Team::CreateById
    field :set_dispute_to_round, RoundType, null: false, mutation: Mutations::Dispute::SetDisputeToRound
    field :remove_dispute_from_round, RoundType, null: false, mutation: Mutations::Dispute::RemoveDisputeFromRound
  end
end
