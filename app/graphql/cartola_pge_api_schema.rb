class CartolaPgeApiSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
  subscription(Types::SubscriptionType)

  # Opt in to the new runtime (default in future graphql-ruby versions)
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST

  # Add built-in connections for pagination
  use GraphQL::Pagination::Connections

  def self.unauthorized_object(error)
    # Add a top-level error to the response instead of returning nil:
    raise GraphQL::ExecutionError, "You don't have PERMISSION to access that content"
  end
end