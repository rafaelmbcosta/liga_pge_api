require 'rails_helper'

module Api
  module V1
    RSpec.describe SeasonWorker do

      before do
        Connection.stubs(:market_status).returns( { "temporada" => Time.now.year, "status_mercado" => 1 } )
        @connection = Connection.market_status
      end

      describe 'season_year' do
        it 'should return current year' do
          expect(SeasonWorker.season_year(@connection)).to eq(Time.now.year)
        end
      end

      after do
        Connection.unstub(:market_status)
      end
    end
  end
end
