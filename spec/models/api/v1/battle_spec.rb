require 'rails_helper'

module Api
  module V1
    RSpec.describe Battle, type: :model do

      let(:season) { FactoryBot.create(:v1_season, year: 2019) }

      let(:dispute_month) do
        return FactoryBot.create(:v1_dispute_month, season: season,
                                                    dispute_rounds: (10..20).to_a)

      end
      let(:round) do
        return FactoryBot.create(:v1_round, number: 11, finished: false, season: season,
                                            dispute_month: dispute_month)
      end
    
      describe 'rounds_avaliable_for_battles' do


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
      end

      describe 'find_battle' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:rival) { FactoryBot.create(:v1_team) }

        it 'should return the battle instance' do
          battle = Battle.create(round: round, first_id: team.id, second_id: rival.id)
          expect(Battle.find_battle(round.id, team, rival)).to eq([battle])
        end
      end

      describe 'find_ghost_battle' do
        let(:team) { FactoryBot.create(:v1_team) }

        it 'it returns battle with nil value' do
          battle = Battle.create(round: round, first_id: team.id, second_id: nil)
          expect(Battle.find_ghost_battle(round.id)).to eq(battle)
        end
      end

      describe 'less_battle_number' do

      end
    end
  end
end