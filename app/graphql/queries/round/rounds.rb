class Queries::Round::Rounds < GraphQL::Schema::Resolver
  description 'Round list'

  argument :number, Integer, required: false
  argument :dispute, ID, required: false

  def resolve(**args)
    params = { season: Season.active }.merge(args)
    Round.where(params)
  end
end