require 'rails_helper'

shared_examples 'closed_market' do

  before do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  describe 'self.close_market' do
    let(:season) { FactoryBot.build(:season) }
    let(:round) { FactoryBot.build(:round, number: 1) }

    before do
      allow(Season).to receive(:active).and_return(season)
      allow(Round).to receive(:get_by_number).and_return(round)
    end

    it 'returns error if market status is not closed' do
      allow(Connection).to receive(:market_status).and_return({ 'market_closed' => false })
      expect { Round.close_market }.to raise_error 'Mercado não está fechado no momento'
    end

    it 'returns error if round is already finished' do
      round.market_closed = true
      allow(Connection).to receive(:market_status).and_return({ 'market_closed' => true, 'rodada_atual' => 1 })
      expect { Round.close_market }.to raise_error 'Rodada atual já está com mercado fechado'
    end

    it 'returns error if round is not active' do
      round.active = false
      allow(Connection).to receive(:market_status).and_return({ 'market_closed' => true, 'rodada_atual' => 1 })
      expect { Round.close_market }.to raise_error 'Rodada atual nem está ativa'
    end

    it 'updates the round' do
      round.update(active: true, market_closed: false)
      allow(Connection).to receive(:market_status).and_return({ 'market_closed' => true, 'rodada_atual' => 1 })
      Round.close_market
      expect(round.market_closed).to be true
    end
  end
end