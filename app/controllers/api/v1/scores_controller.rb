module Api
  module V1
    class ScoresController < ApplicationController
      before_action :authenticate_user, except: [ :index ]

      # GET /scores
      def index
        @scores = Score.all

        render json: @scores
      end
    end
  end
end
