class Api::V1::UserTokenController < Knock::AuthTokenController
  def entity_name
    'Api::V1::User'
  end
end
