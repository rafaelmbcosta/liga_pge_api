require 'rails_helper'

RSpec.describe Currency, type: :model do

  before do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end
      
  let(:dispute_month) { FactoryBot.create(:dispute_month, season: season) }
  let(:season) { FactoryBot.create(:season) }
  let(:round) { season.rounds.first }
  let(:currency) { FactoryBot.build(:currency, difference: 100) }

  describe 'save_currencies' do
    let(:team) { FactoryBot.build(:team) }

    before do
      allow(Connection).to receive(:team_score).and_return({ 'atletas' => [] })
      allow(Team).to receive(:active).and_return([team])
      allow(Currency).to receive(:check_variation).and_return(3)
      allow(Currency).to receive(:find_or_initialize_by).and_return(currency)
    end

    it 'creates currency' do
      expect(Currency.save_currencies(round)).to be true
      expect(currency.difference).to eq(3)
    end
  end

  describe 'check_variation' do
    let(:team_score) do
      return {
        'atletas' => [
          { 'nome' => 'Marcelo Moreno', 'variacao_num' => 3 },
          { 'nome' => 'Edson Cariús', 'variacao_num' => 5.5 }
        ]
      }
    end

    it 'returns variation sum ' do
      expect(Currency.check_variation(team_score)).to eq(8.5)
    end
  end


  # describe 'difference_details' do
  #   let(:team) { FactoryBot.create(:v1_team) }
  #   let(:currency) { Currency.create(difference: 6, round: round, team: team) }
  #   let(:expectation) { [{ value: 12, difference: 6, round: round.number }] }

  #   before do
  #     allow(currency).to receive(:value).and_return(12)
  #   end

  #   it 'returns a hash with details' do
  #     expect(Currency.difference_details([currency])).to eq(expectation)
  #   end
  # end

  # describe 'value' do
  #   let(:team) { FactoryBot.create(:v1_team) }
  #   let(:dispute_month_2) { FactoryBot.create(:v1_dispute_month, season: season) }
  #   let(:dispute_month_3) { FactoryBot.create(:v1_dispute_month, season: season) }
  #   let(:round_2) do
  #     return FactoryBot.create(:v1_round, season: season, finished: true,
  #                                         dispute_month: dispute_month_2, number: 2)
  #   end
  #   let(:round_3) { FactoryBot.create(:v1_round, season: season, dispute_month: dispute_month_3, number: 3) }
  #   let(:currency)  { Currency.create(difference: 35, round: round, team: team) }
  #   let(:currency_2)  { Currency.create(difference: 8, round: round_2, team: team) }
  #   let(:currency_3)  { Currency.create(difference: 4, round: round_3, team: team) }

  #   it 'returns the currency a team had at a specific round' do
  #     expect([currency.value, currency_2.value, currency_3.value]).to eq([135, 143, 147])
  #   end
  # end

  # describe 'order_team_details' do
  #   let(:params) do
  #     return [
  #       { name: '1', difference: 4 },
  #       { name: '2', difference: 8 },
  #       { name: '3', difference: 3 }
  #     ]
  #   end

  #   let(:expectation) do
  #     return [
  #       { name: '2', difference: 8 },
  #       { name: '1', difference: 4 },
  #       { name: '3', difference: 3 }
  #     ]
  #   end

  #   it 'returns teams sorted by difference' do
  #     expect(Currency.order_team_details(params)).to eq(expectation)
  #   end
  # end

  # describe 'dispute_month_team_details' do
  #   let(:team) { FactoryBot.create(:v1_team) }
  #   let(:currency) { Currency.create(difference: 35, round: round, team: team) }
  #   let(:expectation) do
  #     [
  #       {
  #         name: team.name,
  #         player: team.player_name,
  #         difference: 35,
  #         team_symbol: team.url_escudo_png,
  #         details: []
  #       }
  #     ]
  #   end

  #   before do
  #     round.currencies << currency
  #     allow(Currency).to receive(:difference_details).and_return([])
  #   end

  #   it 'returns an array of hashes with the details' do
  #     expect(Currency.dispute_month_team_details(dispute_month, [team])).to eq(expectation)
  #   end
  # end

  # describe 'dispute_month_information' do
  #   let(:team) { FactoryBot.create(:v1_team) }
  #   let(:expectation) do
  #     {
  #       name: dispute_month.name,
  #       id: dispute_month.id,
  #       teams: []
  #     }
  #   end

  #   before do
  #     allow(Currency).to receive(:dispute_month_team_details).and_return([])
  #   end

  #   it 'return a hash with dispute_month details' do
  #     expect(Currency.dispute_month_information(dispute_month, [team])).to eq(expectation)
  #   end
  # end

  # describe 'show_currencies' do
  #   let(:team) { FactoryBot.create(:v1_team) }

  #   before do
  #     season.dispute_months << dispute_month
  #     allow(Season).to receive(:active).and_return(season)
  #     allow(Team).to receive(:active).and_return([team])
  #     allow(Currency).to receive(:dispute_month_information).and_return(nome: 'Abril/Maio')
  #   end

  #   it 'redis save hash if success' do
  #     Currency.show_currencies
  #     expect($redis.get('currencies')).to eq([{ nome: 'Abril/Maio' }].to_json)
  #   end

  #   it 'returns error if it fails' do
  #     allow(Season).to receive(:active).and_return(nil)
  #     expect { Currency.show_currencies }.to raise_error
  #   end
  # end

  # describe 'save_currencies' do
  #   let(:round_control) { FactoryBot.create(:v1_round_control, round: round) }

  #   before do
  #     round.round_control = round_control
  #     allow(Currency).to receive(:rounds_avaliable_to_save_currencies).and_return([round])
  #   end

  #   it 'return true if currencies are saved' do
  #     expect(Currency.save_currencies).to be true
  #   end

  #   it 'updates round_control currencies_generated' do
  #     Currency.save_currencies
  #     expect(round.round_control.currencies_generated).to be true
  #   end

  #   it 'returns error if it fails' do
  #     allow(Currency).to receive(:rounds_avaliable_to_save_currencies).and_return([nil])
  #     expect { Currency.save_currencies }.to raise_error
  #   end
  # end

  # describe 'find_and_update_currencies' do
  #   let(:currency) do
  #     FactoryBot.create(:v1_currency, round: round, team: team,
  #                                     difference: 5)
  #   end
  #   let(:team) { FactoryBot.create(:v1_team) }

  #   before do
  #     allow(Connection).to receive(:team_score).and_return([])
  #     allow(Currency).to receive(:check_variation).and_return(10)
  #     allow(Currency).to receive(:find_by).and_return(currency)
  #     allow(Team).to receive(:active).and_return([team])
  #   end

  #   it 'updates the difference' do
  #     Currency.find_and_update_currencies(round)
  #     expect(currency.difference).to eq(10)
  #   end

  #   it 'returns true' do
  #     expect(Currency.find_and_update_currencies(round)).to be true
  #   end
  # end

  # describe 'rerun_currencies' do
  #   before do
  #     allow(Season).to receive(:active).and_return(season)
  #     season.rounds << round
  #   end

  #   it 'returns true' do
  #     allow(Currency).to receive(:find_and_update_currencies).and_return(true)
  #     expect(Currency.rerun_currencies).to be true
  #   end

  #   it 'returns flow control if it fails' do
  #     allow(Season).to receive(:active).and_return(nil)
  #     expect { Currency.rerun_currencies }.to raise_error
  #   end
  # end
end
