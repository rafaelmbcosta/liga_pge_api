require 'rails_helper'

shared_examples 'check_new_round' do
  before do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  describe 'self.new_round' do
    let(:season) { FactoryBot.build(:season) }
    let(:round) { FactoryBot.build(:round) }

    before do
      allow(Season).to receive(:active).and_return(season)
      allow(Round).to receive(:get_by_number).and_return(round)
    end

    it 'returns error if market status is not the one expected' do
      allow(Connection).to receive(:market_status).and_return(nil)
      expect { Round.new_round }.to raise_error 'Erro: mercado invalido / fechado'
      allow(Connection).to receive(:market_status).and_return({ 'status_mercado' => 2 })
      expect { Round.new_round }.to raise_error 'Erro: mercado invalido / fechado'
    end

    it 'returns error if round already axists' do
      allow(Connection).to receive(:market_status).and_return({'status_mercado' => 1, 'rodada_atual' => 1 })
      round.active = true
      expect { Round.new_round }.to raise_error 'Rodada já existente'
    end

    it 'returns error if round already axists' do
      allow(Connection).to receive(:market_status).and_return({'status_mercado' => 1, 'rodada_atual' => 1 })
      round.update(active: false, finished: true)
      expect { Round.new_round }.to raise_error 'Rodada já está finalizada'
    end

    it 'updates the round' do
      allow(Connection).to receive(:market_status).and_return({'status_mercado' => 1, 'rodada_atual' => 1 })
      round.update(active: false, finished: false)
      Round.new_round
      expect(round.active).to be true
    end
  end

  describe 'finish_previous_round' do
    let(:round) { FactoryBot.build(:round, number: 2) }
    let(:previous_round) { FactoryBot.build(:round, number: 1, finished: false) }

    it 'returns nil if number == 1' do
      expect(previous_round.finish_previous_round).to be nil
    end

    it 'returns true if updated' do
      allow(round).to receive(:previous_round).and_return(previous_round)
      expect(round.finish_previous_round).to be true
      expect(previous_round.finished).to be true
    end
  end
end