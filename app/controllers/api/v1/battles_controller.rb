module Api
  module V1
  class BattlesController < ApplicationController
    before_action :authenticate_user, except: [ :index ]

    # GET /battles
    def index
      @battles = Battle.list_battles

      render json: @battles
    end
  end
end
