require 'active_support/concern'

module Concern::Round::Routines
  extend ActiveSupport::Concern

  included do
    def self.general_tasks_routine
      RoundWorker.perform
      TeamWorker.perform
      # SeasonWorker.perform("season_finished")
    end

    def self.closed_market_routines(round)
      NewBattlesWorker.perform_now(round)
      # BattleWorker.perform("closed_market")
      # ScoresWorker.perform("closed_market")
      # pipeline = Pipeline::Pipe.new({round_id: round_id})
      # pipeline.stage(Pipeline::Battle::StageBattleWorker.new())
      # pipeline.stage(Pipeline::Scores::StageScoresWorker.new())
      # pipeline.executa()
    end

    def self.round_finished_routines
      # ScoresWorker.perform('finished_round')
      # BattleWorker.perform('finished_round')
      # CurrencyWorker.perform
      # SeasonWorker.perform("finished_round")
    end
  end
end
