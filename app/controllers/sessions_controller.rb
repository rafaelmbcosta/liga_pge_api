class SessionsController < ApplicationController

  def logout
    token = request.headers['Authorization']&.split(' ')&.last
    Session.where(key: token).delete_all
  end
end
