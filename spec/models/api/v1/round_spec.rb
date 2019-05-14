require 'rails_helper'

module Api
  module V1
    RSpec.describe Round, type: :model do
      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean
        allow(Round).to receive(:find_dispute_month).and_return(dispute_month)
      end

      let(:season) { FactoryBot.create(:v1_season, year: 2019) }

      let(:dispute_month) do
        return FactoryBot.create(:v1_dispute_month, season: season,
                                                    dispute_rounds: (10..20).to_a)
      end
      let(:data) do
        return {
          'fechamento' => {
            'ano' => 2019, 'mes' => 1,
            'dia' => 1, 'hora' => 14, 'minuto' => 0
          },
          'rodada_atual' => 14,
          'status_mercado' => 1
        }
      end

      describe 'Relationship' do
        it { is_expected.to belong_to :season }
        it { is_expected.to belong_to :dispute_month }
        it { is_expected.to have_many :scores }
        it { is_expected.to have_many :battles }
      end

      describe 'validate uniqueness of name in season' do
        it 'raise error when creating duplicates' do
          FactoryBot.create(:v1_round, number: 11, season: season, dispute_month: dispute_month)
          round = FactoryBot.build(:v1_round, number: 11, season: season,
                                              dispute_month: dispute_month)
          error_message = 'Validation failed: Number Rodada já existente na temporada'
          expect { round.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
        end
      end

      describe 'validates_more_than_two' do
        it 'allow even two rounds active per season' do
          FactoryBot.create(:v1_round, number: 20, finished: false, season: season,  dispute_month: dispute_month)
          FactoryBot.create(:v1_round, number: 21, finished: false, season: season,  dispute_month: dispute_month)
          expect(season.active_rounds.count).to eq(2)
        end
      end

      describe 'self.exist_round?' do
        it 'return true if it exists' do
          FactoryBot.create(:v1_round,
                            finished: false,
                            season: season,
                            dispute_month: dispute_month,
                            number: 13)
          expect(Round.exist_round?(season, 13)).to be true
        end
      end

      describe 'check_new_round' do
        it 'raise error if market status is invalid' do
          allow(Connection).to receive(:market_status).and_return(nil)
          expect(Round.check_new_round.message).to eq('Erro: mercado invalido / fechado')
        end

        it 'return error if round already exist' do
          allow(Round).to receive(:new_round).and_return(data)
          allow(Round).to receive(:exist_round?).and_return(true)
          expect(Round.check_new_round.message).to eq('Rodada já existente')
        end

        it 'return the newly created round' do
          round = FactoryBot.create(:v1_round, finished: false, season: season,
                                               dispute_month: dispute_month, number: 16)
          allow(Connection).to receive(:market_status).and_return(data)
          allow(Round).to receive(:new_round).and_return(round)
          expect(Round.check_new_round).to eq(round)
        end
      end

      describe 'new_round' do
        let(:market_status) { data }
        let(:round) { FactoryBot.create(:v1_round, season: season, dispute_month: dispute_month, number: 16, finished: false) }

        it 'return newly created round  if allowed' do
          season.dispute_months.push(dispute_month)
          expect(Round.new_round(season, market_status).number).to eq(14)
        end

        it 'raise error if round is invalid' do
          season.dispute_months.push(dispute_month)
          Round.new_round(season, market_status)
          expect { Round.new_round(season, 19) }.to raise_error
        end
      end

      describe 'update_market_status' do
        let(:round) { FactoryBot.create(:v1_round, season: season, dispute_month: dispute_month, number: 11) }
        let(:round_control) { RoundControl.create(round: round, market_closed: false) }

        it 'returns true' do
          round.round_control = round_control
          expect(Round.update_market_status([round])).to eq(true)
        end

        it 'changes round control market closed' do
          round.round_control = round_control
          Round.update_market_status([round])
          expect(round_control.market_closed).to be true
        end
      end

      describe 'rounds_allowed_to_generate_battles' do
        let(:round) do
          return  FactoryBot.create(:v1_round, season: season, dispute_month: dispute_month, 
                                    number: 14, market_close: DateTime.new(2019,1,1,0,0,0))
        end
        let(:round_control) { RoundControl.create(round: round, market_closed: false) }
        let(:data_close) do
          return {
            'fechamento' => {
              'ano' => 2019, 'mes' => 1,
              'dia' => 1, 'hora' => 14, 'minuto' => 0
            },
            'rodada_atual' => 14,
            'status_mercado' => 2,
            'market_closed' => true,
          }
        end

        it 'return array of allowed rounds' do
          round.round_control = round_control
          allow(Connection).to receive(:market_status).and_return(data_close)
          travel_to (round.market_close + 1.day)
          raise "now: #{DateTime.now} round: #{round.market_close}".inspect
          expect(Round.rounds_allowed_to_generate_battles.first).to eq(round)
          travel_back
        end

        it 'return empty if no rounds meet the conditions' do
          market_status = data
          market_status['status_mercado'] = 4
          allow(Connection).to receive(:market_status).and_return(market_status)
          expect(Round.rounds_allowed_to_generate_battles).to eq([])
        end
      end

      describe 'close_market' do
        it 'return true if success' do
          expect(Round.close_market).to be true
        end

        it 'return error message if it fails' do
          expect(Round.close_market.message).to eq('Data finalizada antes da data prevista')
        end
      end
    end
  end
end
