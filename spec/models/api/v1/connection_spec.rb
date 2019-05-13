require 'rails_helper'

module Api
  module V1
    RSpec.describe Round, type: :model do
      let(:market_status) do
        return {
          'rodada_atual' => 1, 'status_mercado' => 2,
          'game_over' => false, 'temporada' => 2019
        }
      end

      describe 'self.current_round' do
        it 'returns the api round number' do
          allow(Connection).to receive(:market_status).and_return(market_status)
          expect(Connection.current_round).to eq(1)
        end
      end
    end
  end
end
