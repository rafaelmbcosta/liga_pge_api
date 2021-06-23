class NewScoresWorker < ApplicationJob
  queue_as :default

  def perform(round)
    Score.create_scores(round)
  end
end