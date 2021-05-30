class Mutations::Season::Create < GraphQL::Schema::Mutation
  description 'Create Season'

  null true

  argument :year, Integer, required: false

  def resolve(year: Integer)
    Season.new_season
  rescue StandardError => e
    raise e.message
  end

  def self.authorized?(_object, context)
    super && context[:current_user]
  end
end
