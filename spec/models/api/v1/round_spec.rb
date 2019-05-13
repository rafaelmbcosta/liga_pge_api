require 'rails_helper'

module Api
  module V1
    RSpec.describe Round, type: :model do
      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean
        Round.stubs(:find_dispute_month).returns(dispute_month)
      end

      let(:season) { FactoryBot.create(:v1_season, year: 2019) }
      let(:dispute_month) { FactoryBot.create(:v1_dispute_month, season: season, 
                                              dispute_rounds: (10..20).to_a) }
      let(:data) { { 'ano' => 2019, 'mes' => 1, 'dia' => 1, 'hora' => 14, 'minuto' => 0 } }

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
          Round.stubs(:exist_round?).returns(true)
          Connection.stubs(:market_status).returns(nil)
          expect(FlowControl.first.message).to eq('Erro: mercado invalido / fechado')
        end

        it 'return true round already exist' do
          Connection.stubs(:market_status).returns(data)
          Round.stubs(:exist_round?).returns(13)
          expect(Round.check_new_round).to be true
        end

        it 'return the newly created round' do
          Connection.stubs(:market_status).returns({ 'rodada_atual' => 3, 'fechamento' => data })
          Round.unstub(:exist_round?)
          Season.unstub(:active)
        end
      end

      describe 'new_round' do
        it 'return true if allowed' do
          season.dispute_months.push(dispute_month)
          expect(Round.new_round(season, market_status)).to be true
        end

        it 'raise error if round is invalid' do
          season.dispute_months.push(dispute_month)
          Round.new_round(season, market_status)
          expect { Round.new_round(season, 19) }.to raise_error
        end
      end

      after do
        Connection.unstub(:market_status)
        Round.unstub(:find_dispute_month)
      end
    end
  end
end
