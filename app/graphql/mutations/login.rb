class Mutations::Login < GraphQL::Schema::Mutation
  description 'User Login'

  argument :email, String, required: true
  argument :password, String, required: true

  def resolve(email: String, password: String)
    if user = User.where(email: email).first&.authenticate(password)
      auth = Knock::AuthToken.new payload: { sub: user.id }
      user.sessions.create(key: auth.token)
      return auth.token
    end
  end
end