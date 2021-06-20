class NewBattlesWorker < ApplicationJob
  queue_as :default

  after_perform :show_battles

  def perform(round)
    Battle.create_battles(round)
  end

  private
  def show_battles
    Battle.show_battles
  end
end