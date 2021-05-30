class Queries::Tean::List < GraphQL::Schema::Resolver
  description 'Team list'

  argument :active, Boolean, required: false

  def resolve(**args)
    Team.all.where(args)
  end
end