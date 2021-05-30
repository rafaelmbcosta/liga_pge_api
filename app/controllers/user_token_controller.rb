class UserTokenController < Knock::AuthTokenController
  def entity_name
    'User'
  end

  def create
    if user = User.where(email: auth_params["email"]).first&.authenticate(auth_params["password"])
      user.sessions.create(key: auth_token)
    end
    render json: auth_token, status: :created
  end
end
