require 'active_support/concern'

module Concern::Round::CloseMarket
  extend ActiveSupport::Concern

  included do
    def self.close_market
      puts 'Closed market job starting...'
      market_status = Connection.market_status
      raise 'Mercado não está fechado no momento' unless market_status['market_closed']

      round = get_by_number(market_status['rodada_atual'])
      raise 'Rodada atual já está com mercado fechado' if round.market_closed

      raise 'Rodada atual nem está ativa' unless round.active

      round.update(market_closed: true)
      puts '...done !'
    end
  end
end
