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
        let(:team) { FactoryBot.create(:v1_team) }

        it 'return true if battles succefully generated' do
          expect(Battle.create_battles).to be true
        end

        it 'returns a flow control if battles are odd' do
          allow(Team).to receive(:new_battle_teams).and_return([team])
          allow(Battle).to receive(:rounds_avaliable_for_battles).and_return([round])
          expect(Battle.create_battles).to be_instance_of(FlowControl)
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

      describe 'show_battle_data' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:rival) { FactoryBot.create(:v1_team) }
        let(:battle) { Battle.create(round: round, first_id: team.id, second_id: rival.id) }
        let(:expectation) do
          return {
            first_name: "#{team.player_name} ( #{team.name} )",
            second_name: "#{rival.player_name} ( #{rival.name} )",
            first_team_symbol: team.url_escudo_png,
            second_team_symbol: rival.url_escudo_png
          }
        end

        it 'returns a hash with battle data' do
          expect(Battle.show_battle_data(battle, [team, rival])).to eq(expectation)
        end
      end

      describe 'show_list_battles' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:rival) { FactoryBot.create(:v1_team) }
        let(:battle) { Battle.create(round: round, first_id: team.id, second_id: rival.id) }
        let(:expectation) do
          return [{
            first_name: "#{team.player_name} ( #{team.name} )",
            second_name: "#{rival.player_name} ( #{rival.name} )",
            first_team_symbol: team.url_escudo_png,
            second_team_symbol: rival.url_escudo_png
          }]
        end

        it 'return array of battle data' do
          expect(Battle.show_list_battles([team, rival], [battle])).to eq(expectation)
        end
      end

      describe 'battles_to_be_shown' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:rival) { FactoryBot.create(:v1_team) }
        let(:battle) { Battle.create(round: round, first_id: team.id, second_id: rival.id) }

        before do
          allow(Battle).to receive(:where).and_return([battle])
        end

        it 'returns all battles where season is active' do
          expect(Battle.battles_to_be_shown).to eq(round.id => [battle])
        end
      end

      describe 'order_battle_report' do
        let(:original) do
          return [
            { round: 1, battles: [] },
            { round: 3, battles: [] },
            { round: 2, battles: [] }
          ]
        end

        let(:expectation) do
          return [
            { round: 3, battles: [] },
            { round: 2, battles: [] },
            { round: 1, battles: [] }
          ]
        end

        it 'returns array ordered by the round reverse' do
          expect(Battle.order_battle_report(original)).to eq(expectation)
        end
      end

      describe 'battle_report' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:rival) { FactoryBot.create(:v1_team) }
        let(:battle) { Battle.create(round: round, first_id: team.id, second_id: rival.id) }
        let(:expectation) do
          return [
            { battles: [], round: 11 }
          ]
        end

        it 'return a list of battle groups' do
          allow(Battle).to receive(:show_list_battles).and_return([])
          expect(Battle.battle_report({ round.id => [battle] }, [team, rival])).to eq(expectation)
        end
      end

      describe 'show_battles' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:rival) { FactoryBot.create(:v1_team) }
        let(:battle) { Battle.create(round: round, first_id: team.id, second_id: rival.id) }

        it 'builds the battle service' do
          allow(Battle).to receive(:battles_to_be_shown).and_return([battle])
          allow(Team).to receive(:all).and_return([team, rival])
          allow(Battle).to receive(:battle_report).and_return([])
          allow(Battle).to receive(:order_battle_report).and_return([])
          expect(Battle.show_battles).to be_empty
        end
      end

      describe 'list_battles' do
        it 'returns whatever redis have' do
          expect(Battle.list_battles).to eq('[]')
        end
      end

      describe 'team_score' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:scores) do
          return FactoryBot.create(:v1_score, final_score: 25, round: round,
                                              team: team)
        end

        it 'return its final score' do
          expect(round.team_score(team.id, [scores])).to eq(25)
        end
      end

      describe 'draw?' do
        it 'returns true if difference <= 5' do
          expect(Battle.draw?(2, 4)).to be true
        end

        it 'returns false if difference > 5' do
          expect(Battle.draw?(2, 8)).to be false
        end
      end

      describe 'check_winner' do
        let(:battle) { Battle.new }

        it 'returns [false, 0] if its a draw' do
          allow(battle).to receive(:draw).and_return(true)
          expect(battle.check_winner(5, 5)).to eq([false, 0])
        end

        it 'returns [false, 0] if its a loss' do
          allow(battle).to receive(:draw).and_return(false)
          expect(battle.check_winner(5, 8)).to eq([false, 0])
        end

        it 'returns [true, 10] if tis a win' do
          allow(battle).to receive(:draw).and_return(false)
          expect(battle.check_winner(15, 5)).to eq([true, 10])
        end
      end

      describe 'battle_results' do
        let(:battle) { Battle.new(round: round) }
        let(:team) { FactoryBot.create(:v1_team) }
        let(:scores) { [FactoryBot.create(:v1_score, round: round, team: team)] }

        it 'returns true if saved properly' do
          allow(round).to receive(:team_score).and_return(20)
          expect(battle.battle_results(scores, round)).to be true
        end

        it 'raise error if save dont work' do
          expect { battle.battle_results(scores, round) }.to raise_error
        end
      end

      describe 'update_battle_scores_round' do
        let(:battle) { Battle.new }
        let(:score) { Score.new }

        it 'returns true in case of success' do
          allow(round).to receive(:scores).and_return([score])
          allow(round).to receive(:battles).and_return([battle])
          allow(battle).to receive(:battle_results).and_return(true)
          expect(Battle.update_battle_scores_round(round)).to be true
        end
      end

      describe 'update_battle_scores' do
        let(:round_control) { RoundControl.create(round: round) }

        it 'returns true if success' do
          allow(Round).to receive(:rounds_with_battles_to_update).and_return([])
          expect(Battle.update_battle_scores).to be true
        end

        it 'changes battle_scores_updated to true' do
          round.round_control = round_control
          allow(Round).to receive(:rounds_with_battles_to_update).and_return([round])
          allow(Battle).to receive(:update_battle_scores_round).and_return(true)
          Battle.update_battle_scores
          expect(round.round_control.battle_scores_updated).to be true
        end

        it 'returns flow control if it fails' do
          allow(Round).to receive(:rounds_with_battles_to_update).and_return([round])
          expect(Battle.update_battle_scores).to be_instance_of(FlowControl)
        end
      end
    end
  end
end
