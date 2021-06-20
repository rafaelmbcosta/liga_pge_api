require 'rails_helper'

RSpec.describe Battle, type: :model do
  it_behaves_like 'creation'
  it_behaves_like 'show_battles'

  describe 'find_battle' do
    let(:team) { FactoryBot.create(:team, id_tag: 1) }
    let(:rival) { FactoryBot.create(:team, id_tag: 2) }
    let(:season) { FactoryBot.create(:season, year: Time.now.year) }
    let(:round) { season.rounds.take }

    it 'returns the battle instance' do
      battle = Battle.create(round: round, first_id: team.id, second_id: rival.id)
      expect(Battle.find_battle(round.id, team, rival)).to eq([battle])
    end
  end
end
#   let(:season) { FactoryBot.create(:v1_season, year: 2019) }

#   let(:dispute_month) do
#     return FactoryBot.create(:v1_dispute_month, season: season,
#                                                 dispute_rounds: (10..20).to_a)
#   end
#   let(:round) do
#     return FactoryBot.create(:v1_round, number: 11, finished: false, season: season,
#                                         dispute_month: dispute_month)
#   end

#   describe 'rounds_avaliable_for_battles' do
#     it 'returns empty array if conditions are not met' do
#       expect(Battle.rounds_avaliable_for_battles).to eq([])
#     end

#     it 'returns array of rounds that match conditions' do
#       round_control = RoundControl.create(round: round, market_closed: true,
#                                           generating_battles: false,
#                                           battles_generated: false)
#       round.round_control = round_control
#       expect(Battle.rounds_avaliable_for_battles).to eq([round])
#     end
#   end

#   describe 'create_battles' do
#     let(:team) { FactoryBot.create(:v1_team) }

#     it 'return true if battles succefully generated' do
#       expect(Battle.create_battles).to be true
#     end

#     it 'returns a flow control if battles are odd' do
#       allow(Team).to receive(:new_battle_teams).and_return([team])
#       allow(Battle).to receive(:rounds_avaliable_for_battles).and_return([round])
#       expect { Battle.create_battles }.to raise_error
#     end
#   end





#   describe 'show_list_battles' do
#     let(:team) { FactoryBot.create(:v1_team) }
#     let(:rival) { FactoryBot.create(:v1_team) }
#     let(:battle) { Battle.create(round: round, first_id: team.id, second_id: rival.id) }
#     let(:expectation) do
#       return [{
#         first_name: "#{team.player_name} ( #{team.name} )",
#         second_name: "#{rival.player_name} ( #{rival.name} )",
#         first_team_symbol: team.url_escudo_png,
#         second_team_symbol: rival.url_escudo_png
#       }]
#     end

#     it 'return array of battle data' do
#       expect(Battle.show_list_battles([team, rival], [battle])).to eq(expectation)
#     end
#   end

#   describe 'order_battle_report' do
#     let(:original) do
#       return [
#         { round: 1, battles: [] },
#         { round: 3, battles: [] },
#         { round: 2, battles: [] }
#       ]
#     end





#   describe 'list_battles' do
#     it 'returns whatever redis have' do
#       expect(Battle.list_battles).to eq('[]')
#     end
#   end

#   describe 'team_score' do
#     let(:team) { FactoryBot.create(:v1_team) }
#     let(:scores) do
#       return FactoryBot.create(:v1_score, final_score: 25, round: round,
#                                           team: team)
#     end

#     it 'return its final score' do
#       expect(round.team_score(team.id, [scores])).to eq(25)
#     end
#   end

#   describe 'draw?' do
#     it 'returns true if difference <= 5' do
#       expect(Battle.draw?(2, 4)).to be true
#     end

#     it 'returns false if difference > 5' do
#       expect(Battle.draw?(2, 8)).to be false
#     end
#   end

#   describe 'check_winner' do
#     let(:battle) { Battle.new }

#     it 'returns [false, 0] if its a draw' do
#       allow(battle).to receive(:draw).and_return(true)
#       expect(battle.check_winner(5, 5)).to eq([false, 0])
#     end

#     it 'returns [false, 0] if its a loss' do
#       allow(battle).to receive(:draw).and_return(false)
#       expect(battle.check_winner(5, 8)).to eq([false, 0])
#     end

#     it 'returns [true, 10] if tis a win' do
#       allow(battle).to receive(:draw).and_return(false)
#       expect(battle.check_winner(15, 5)).to eq([true, 10])
#     end
#   end

#   describe 'battle_results' do
#     let(:battle) { Battle.new(round: round) }
#     let(:team) { FactoryBot.create(:v1_team) }
#     let(:scores) { [FactoryBot.create(:v1_score, round: round, team: team)] }

#     it 'returns true if saved properly' do
#       allow(round).to receive(:team_score).and_return(20)
#       expect(battle.battle_results(scores, round)).to be true
#     end

#     it 'raise error if save dont work' do
#       expect { battle.battle_results(scores, round) }.to raise_error
#     end
#   end

#   describe 'update_battle_scores_round' do
#     let(:battle) { Battle.new }
#     let(:score) { Score.new }

#     it 'returns true in case of success' do
#       allow(round).to receive(:scores).and_return([score])
#       allow(round).to receive(:battles).and_return([battle])
#       allow(battle).to receive(:battle_results).and_return(true)
#       expect(Battle.update_battle_scores_round(round)).to be true
#     end
#   end

#   describe 'update_battle_scores' do
#     let(:round_control) { RoundControl.create(round: round) }

#     it 'returns true if success' do
#       allow(Round).to receive(:rounds_with_battles_to_update).and_return([])
#       expect(Battle.update_battle_scores).to be true
#     end

#     it 'changes battle_scores_updated to true' do
#       round.round_control = round_control
#       allow(Round).to receive(:rounds_with_battles_to_update).and_return([round])
#       allow(Battle).to receive(:update_battle_scores_round).and_return(true)
#       Battle.update_battle_scores
#       expect(round.round_control.battle_scores_updated).to be true
#     end

#     it 'returns flow control if it fails' do
#       allow(Round).to receive(:rounds_with_battles_to_update).and_return([round])
#       expect { Battle.update_battle_scores }.to raise_error
#     end
#   end
# end
