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

        it 'returns the battle instance' do
          battle = Battle.create(round: round, first_id: team.id, second_id: rival.id)
          expect(Battle.find_battle(round.id, team, rival)).to eq([battle])
        end
      end

      describe 'find_ghost_battle' do
        let(:team) { FactoryBot.create(:v1_team) }

        it 'returns battle with nil value' do
          battle = Battle.create(round: round, first_id: team.id, second_id: nil)
          expect(Battle.find_ghost_battle(round.id)).to eq(battle)
        end
      end

      describe 'less_battle_number' do
        it 'returns the lower number' do
          history = { 'p1' => 4, 'p2' => 4, 'p3' => 3, 'p4' => 3 }
          expect(Battle.lower_battle_number(history)).to eq(3)
        end
      end

      describe 'pick_team' do
        let(:teams) { (1..5).to_a }

        it 'removes a team from the list and return it' do
          expect(teams).not_to include(Battle.pick_team(teams)[0])
        end

        it 'returns teams with one less team' do
          expect(Battle.pick_team(teams)[1].size).to eq(4)
        end
      end

      describe 'create_battle' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:rival) { FactoryBot.create(:v1_team) }

        it 'create a battle' do
          expect(Battle.create_battle(team, rival, round)).to be_instance_of(Battle)
        end
      end

      describe 'create battles' do
        it 'create a battle' do
          allow(Battle).to receive(:rounds_avaliable_for_battles).and_return([round])
          allow(Battle).to receive(:generate_battles).and_return(true)
          expect(Battle.create_battles).to be true
        end
      end

      describe 'generate_battles' do
        it 'returns empty array if success' do
          RoundControl.create(round: round, market_closed: true,
                              generating_battles: false,
                              battles_generated: false)
          allow(Battle).to receive(:sort_battle).and_return([])
          expect(Battle.generate_battles(round)).to eq([])
        end

        it 'raise error if teams are odd' do
          allow(Team).to receive(:new_battle_teams).and_return((1..3).to_a)
          error_message = 'cannot generate battle with ODD teams'
          expect { Battle.generate_battles(round) }.to raise_error(RuntimeError, error_message)
        end
      end

      describe 'sort_rival' do
        let(:history) { { 'p1' => 4, 'p2' => 4, 'p3' => 3, 'p4' => 3 } }
        let(:teams) { %w[p1 p2 p3 p4] }

        it 'pop a rival from the list of teams' do
          expectation = %w[p3 p4].include?(Battle.sort_rival(history, 3, teams)[0])
          expect(expectation).to be true
        end

        it 'returns the list of teams without the picked one' do
          expect(Battle.sort_rival(history, 3, teams)[1].size).to eq(3)
        end
      end

      describe 'check_encounters' do
        let(:p1) { Team.create(name: 'p1', slug: 'p1') }
        let(:p2) { Team.create(name: 'p12', slug: 'p2') }
        let(:p3) { Team.create(name: 'p13', slug: 'p3') }
        let(:teams) { [p2, p3] }

        it 'returns the battle history of the chosen team' do
          Battle.create(first_id: p1.id, second_id: p2.id, round: round)
          expected_result = { p2 => 1, p3 => 0 }
          expect(Battle.check_encounters(p1, teams, round)).to eq(expected_result)
        end
      end

      describe 'sort_battle' do
        let(:p1) { Team.create(name: 'p1', slug: 'p1') }
        let(:p2) { Team.create(name: 'p12', slug: 'p2') }
        let(:p3) { Team.create(name: 'p13', slug: 'p3') }
        let(:teams) { [p1, p2, p3] }

        it 'returns empty array if success' do
          expect(Battle.sort_battle(teams, round)).to eq([])
        end
      end
    end
  end
end
