class Queries::Round::Pool < GraphQL::Schema::Resolver
  description "Returns all rounds that doesn't belong to any dispute month"

  def resolve
    Season.active.rounds.where(dispute_month_id: nil)
  end

  def self.authorized?(_object, context)
    super && context[:current_user]
  end
end