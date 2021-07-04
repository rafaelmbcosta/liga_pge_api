require 'active_support/concern'

module Concern::Round::Routines
  extend ActiveSupport::Concern

  included do
    def self.general_tasks_routine
      NewRoundWorker.perform_now
      MarketClosedWorker.perform_now
      TeamWorker.perform_now
    end

    def self.closed_market_routines(round)
      NewBattlesWorker.perform_now(round)
      NewScoresWorker.perform_now(round)
    end

    def self.round_finished_routines(round)
      UpdateScoresWorker.perform_now(round)
      UpdateBattlesWorker.perform_now(round)
      # CurrencyWorker.perform
      # SeasonWorker.perform("finished_round")
    end
  end
end
