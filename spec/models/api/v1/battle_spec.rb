require 'rails_helper'

module Api
  module V1
    RSpec.describe Battle, type: :model do
    
      describe 'rounds_avaliable_for_battles' do
        let(:season) { FactoryBot.create(:v1_season, year: 2019) }

        let(:dispute_month) do
          return FactoryBot.create(:v1_dispute_month, season: season,
                                                      dispute_rounds: (10..20).to_a)

        end
        let(:round) do
          return FactoryBot.create(:v1_round, number: 11, finished: false, season: season,
                                              dispute_month: dispute_month )
        end

        it 'returns empty array if conditions are not met' do
          expect(Battle.rounds_avaliable_for_battles).to eq([])
        end

        it 'returns array of rounds that match conditions' do
          round_control = RoundControl.create(round: round, market_closed: true, 
                                              generating_battles: false,
                                              battles_generated: false)
          round.round_control = round_control
          expect(Battle.rounds_avaliable_for_battles).to eq([round])
        end
      end

      describe 'create_battles' do
        it 'return true if battles succefully generated' do
          expect(Battle.create_battles).to be true
        end

        it 'return error message if something goes wrong' do
          expect(Battle.generate_battles).not_to be true
        end
      end
    end
  end
end