module Api
  module V1
    class SeasonsController < ApplicationController
      before_action :authenticate_user, except: [:scores]

      def scores
        @season_scores = $redis.get("season_scores")
        render json: @season_scores
      end
    end
  end
end
