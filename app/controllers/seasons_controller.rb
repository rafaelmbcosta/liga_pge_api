class SeasonsController < ApplicationController
  def scores
    @season_scores = $redis.get("season_scores")
    render json: @season_scores
  end
end
