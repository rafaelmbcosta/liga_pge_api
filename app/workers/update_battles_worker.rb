class UpdateBattlesWorker

  after_perform :show_league_scores

  def perform(round)
    Battle.update_battle_scores(round)
  end

  def show_league_scores
    Battle.show_league
  end
end