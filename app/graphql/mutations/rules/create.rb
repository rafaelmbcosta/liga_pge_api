class Mutations::Rules::Create < GraphQL::Schema::Mutation
  description "Creating a new Rule"
  argument :text, String, required: true

  def resolve(text: String)
    Rule.create(text: text)
  rescue StandardError => e
    raise e.message
  end

  def self.authorized?(_object, context)
    super && context[:current_user]
  end
end
