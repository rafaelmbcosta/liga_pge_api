class Api::V1::ApiController < ApplicationController

  private

  def authenticate_user
    authenticate_for Api::V1::User
  end
end
