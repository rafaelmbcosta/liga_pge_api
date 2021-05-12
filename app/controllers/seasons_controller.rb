class SeasonsController < ApplicationController
  before_action :authenticate_user, except: %i[scores]

  def scores
    @season_scores = $redis.get("season_scores")
    render json: @season_scores
  end

  def current
    render json: Season.active
  end
end
