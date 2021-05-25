require 'rails_helper'

RSpec.describe SeasonWorker do
  before do
    allow(Connection).to receive(:market_status).and_return('temporada' => Time.now.year, 'status_mercado' => 1)
  end

  let(:connection) { Connection.market_status }

  describe 'season_year' do
    it 'returns current year' do
      expect(SeasonWorker.season_year(connection)).to eq(Time.now.year)
    end
  end
end
