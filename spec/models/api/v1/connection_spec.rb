require 'rails_helper'

module Api
  module V1
    RSpec.describe Round, type: :model do
      before do
        @mock_market_status = { "rodada_atual" => 1, "status_mercado" => 2, 
                                "game_over" => false, "temporada" => 2019 }
      end

      describe 'self.current_round' do
        it 'should return the api round number' do
          Connection.stubs(:market_status).returns(@mock_market_status)
          expect(Connection.current_round).to eq(1)
          Connection.unstub(:market_status)
        end
      end
    end
  end
end