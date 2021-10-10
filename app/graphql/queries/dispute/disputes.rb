class Queries::Dispute::Disputes < GraphQL::Schema::Resolver
  description "Dispute months"

  def resolve
    DisputeMonth.where(season: Season.active).includes(:rounds).order('id desc')
  end
end
