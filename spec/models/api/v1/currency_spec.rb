require 'rails_helper'

module Api
  module V1
    RSpec.describe Currency, type: :model do
      let(:season) { FactoryBot.create(:v1_season) }
      let(:dispute_month) { FactoryBot.create(:v1_dispute_month, season: season) }
      let(:round) { FactoryBot.create(:v1_round, season: season, dispute_month: dispute_month) }

      describe 'rounds_avaliable_to_save_currencies' do
        before do
          allow(Round).to receive(:rounds_avaliable_to_save_currencies).and_return([round])
        end

        it 'returns all rounds avaliable' do
          expect(Currency.rounds_avaliable_to_save_currencies).to eq([round])
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

      describe 'save_currencies_round' do
        let(:team) { FactoryBot.create(:v1_team) }

        before do
          allow(Connection).to receive(:team_score).and_return([])
          allow(Currency).to receive(:check_variation).and_return(3)
          allow(Team).to receive(:active).and_return([team])
        end
        
        it 'creates currency' do
          Currency.save_currencies_round(round)
          expect(Currency.find { |c| c.round_id == round.id && c.team_id == team.id } .difference).to eq(3)
        end
      end
    end
  end
end
