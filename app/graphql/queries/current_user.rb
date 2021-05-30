class Queries::CurrentUser < GraphQL::Schema::Resolver

  description 'Currently logged user'

  def resolve
    context[:current_user]
  end

  def self.authorized?(_object, context)
    super && context[:current_user]
  end
end
