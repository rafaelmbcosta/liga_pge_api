require 'rails_helper'

module Api
  module V1
    shared_examples 'show_league' do
      let(:model) { described_class }
      let(:season) { FactoryBot.create(:v1_season) }
      let(:dispute_month) { FactoryBot.create(:v1_dispute_month, season: season) }

      describe 'show_league' do

        before do
          season.dispute_months << dispute_month
          allow(Season).to receive(:active).and_return(season)
          allow(model).to receive(:dispute_month_league_report).and_return(status: 'ok')
        end

        it 'saves all results to redis' do
          expect(model.show_league).to eq([{ status: 'ok' }])
        end
      end

      describe 'dispute_month_league_report' do
        let(:expectation) { { name: dispute_month.name, id: dispute_month.id, players: [] } }
        let(:team) { FactoryBot.create(:v1_team) }
        let(:opponent) { FactoryBot.create(:v1_team) }

        before do
          allow(model).to receive(:league_report_teams).and_return([])
        end

        it 'Returns the hash with all players' do
          expect(model.dispute_month_league_report(dispute_month, [team])).to eq(expectation)
        end
      end

      describe 'opponent' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:opponent) { FactoryBot.create(:v1_team) }
        let(:battle) { Battle.new(first_id: team.id, second_id: opponent.id) }
        let(:teams) { [team, opponent] }

        it 'returns the other second team' do
          allow(teams).to receive(:find).and_return(opponent)
          expect(model.opponent(battle, team, teams)).to eq(opponent.name)
        end

        it 'returns ghost if second team is nil' do
          battle.second_id = nil
          expect(model.opponent(battle, team, teams)).to eq('Fantasma')
        end
      end

      describe 'league_battle_result' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:second_team) { FactoryBot.create(:v1_team) }

        let(:battle) do 
          Battle.new(first_id: team.id, second_id: second_team.id, 
                     first_points: 10, second_points: 4, draw: false,
                     first_win: false, second_win: false)
        end

        let(:second_battle) do 
          Battle.new(first_id: second_team.id, second_id: team.id, 
                     first_points: 4, second_points: 10, draw: false,
                     first_win: false, second_win: true)
        end

        it 'returns [1,0] if its a draw' do
          battle.draw = true
          expect(model.league_battle_result(battle, team)).to eq([1,0])
        end

        it 'returns [3, difference] in case of win and he its the first team' do
          battle.first_win = true
          expect(model.league_battle_result(battle, team)).to eq([3, 6])
        end

        it 'returns [3, difference] in case of win and he its the second team' do
          expect(model.league_battle_result(second_battle, team)).to eq([3, 6])
        end

        it 'returns [0,0] if its a loss' do
          battle.first_win = true
          expect(model.league_battle_result(battle, second_team)).to eq([0, 0])
        end
      end

      describe 'team_details' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:second_team) { FactoryBot.create(:v1_team) }

        let(:battle) do 
          Battle.new(first_id: team.id, second_id: second_team.id, 
                     first_points: 10, second_points: 4, draw: false,
                     first_win: false, second_win: false, round: round)
        end

        let(:round) { FactoryBot.build(:v1_round, number: 2) }

        let(:expectation) do
          [
            {
              round: 2, points: 6, diff_points: 70, 
              opponent: second_team.name
            }
          ]
        end

        before do
          allow(battle).to receive(:round).and_return(round)
          allow(model).to receive(:opponent).and_return(second_team.name)
          allow(model).to receive(:league_battle_result).and_return([6, 70])
        end

        it 'returns [] if there is no battles' do
          expect(model.team_details([team, second_team], team, [])).to eq([])
        end

        it  'returns array of details if it succeeds' do
          expect(model.team_details([team, second_team], team, [battle])).to eq(expectation)
        end
      end
    end
  end
end
