class Queries::Team::List < GraphQL::Schema::Resolver
  description 'Team list'

  argument :active, Boolean, required: false

  def resolve(**args)
    Team.all.where(args).order('created_at desc')
  end
end