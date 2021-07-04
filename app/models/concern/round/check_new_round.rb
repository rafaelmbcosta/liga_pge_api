require 'active_support/concern'

module Concern::Round::CheckNewRound
  extend ActiveSupport::Concern

  included do
    # only execute when market is open
    def self.new_round
      puts 'New round job starting...'
      season = Season.active
      market_status = Connection.market_status
      raise 'Erro: mercado invalido / fechado' if market_status.nil? || market_status['status_mercado'] != 1

      round = Round.get_by_number(market_status['rodada_atual'])
      raise 'Rodada já existente' if round&.active

      raise 'Rodada já está finalizada' if round&.finished
      round.update(active: true)
      puts '...done !'
    end

    def finish_previous_round
      return nil if number == 1

      # yet to be implemented
      # return season.finish if number == 38

      previous_round.update(finished: true)
      true
    end

    # def finish_season
      # finish season if round is 38 and its finished.
    # end
  end
end
