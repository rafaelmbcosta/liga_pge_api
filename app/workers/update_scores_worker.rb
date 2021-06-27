# Implement some jobs according to the flow
class UpdateScoresWorker < ApplicationJob

  after_perform :show_scores

  def perform(round)
    Score.update_scores(round)
  end

  private
  def show_scores
    Score.show_scores
  end
end