require_dependency "season/application_controller"

module Season
  class SeasonsController < ApplicationController
    def index
      render json: { message: 'Success !'}, status: 200
    end
  end
end
