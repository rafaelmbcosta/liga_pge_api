require 'rails_helper'

RSpec.describe Round, type: :model do
  it_behaves_like 'check_new_round'
  it_behaves_like 'closed_market'

  before do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  let(:season) { FactoryBot.build(:season, finished: false) }
  let(:active_round) { FactoryBot.build(:round, finished: false, active: true, number: 1) }
  let(:inactive_round) { FactoryBot.build(:round, finished: true, active: false, number: 2) }

  describe 'main methods' do
    before(:each) do
      allow(Season).to receive(:active).and_return(season)
      allow(season).to receive(:rounds).and_return([active_round, inactive_round])
      inactive_round.season = season
    end

    it 'self.active returns the active round' do
      expect(Round.active).to eq(active_round)
    end

    it 'self.get_by_number find the corresponding round' do
      expect(Round.get_by_number({ 'rodada_atual' => 1 })).to eq(active_round)
      expect(Round.get_by_number({ 'rodada_atual' => 2 })).to eq(inactive_round)
    end

    it 'self.previous returns previous round' do
      expect(inactive_round.previous_round).to eq(active_round)
    end
  end
end
