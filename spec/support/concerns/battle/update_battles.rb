require 'rails_helper'

shared_examples 'update_battles' do
  before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  let(:season) { Season.create(year: Time.now.year) }
  let(:round) { season.rounds.take }
  let(:team) { FactoryBot.create(:team, id_tag: 1) }
  let(:rival) { FactoryBot.create(:team, id_tag: 2) }
  let(:battle) { Battle.create(round: round, first_id: team.id, second_id: rival.id) }
  let(:score_1) { FactoryBot.create(:score, team: team, round: round, final_score: 20) }
  let(:score_2) { FactoryBot.create(:score, team: rival, round: round, final_score: 5 ) }
  let(:scores) { [score_1] }

  describe 'update_battle_scores' do
    before do
      round.battles << battle
      allow(battle).to receive(:battle_results).and_return(true)
    end

    it 'returns true aflter updating results' do
      expect(Battle.update_battle_scores(round)).to be true
    end
  end

  describe 'battle_results' do
    before do
      round.scores << score_1
      round.scores << score_2
    end

    it 'returns true if saved properly' do
      battle.battle_results
      expect(battle.first_win).to be true
      expect(battle.second_win).to be false
      expect(battle.draw).to be false
    end
  end


  describe 'ghost related conditions' do

    let(:ghost_team) { FactoryBot.create(:team, id_tag: 4) }
    let(:ghost_buster) { FactoryBot.create(:score, team: ghost_team, round: round, final_score: 20) }
    let(:ghost_battle) { Battle.create(round: round, first_id: ghost_team.id, second_id: nil) }

    before do
      round.battles << ghost_battle
      # allow(scores).to receive(:find_by).and_return(ghost_buster)
    end

    it 'returns ghost score if team_id is nil' do
      allow(battle).to receive(:ghost_score).and_return(18)
      expect(battle.team_score(nil, scores, round)).to eq(18)
    end

    it 'raises error if doesnt find the ghost opponent' do
      expect { battle.ghost_buster_score(scores, round) }.to raise_error('Oponente do Fantasma não encontrado')
    end

    it 'returns the ghost buster score' do
      scores << ghost_buster
      expect(battle.ghost_buster_score(scores, round)).to eq(ghost_buster.final_score)
    end
  end

  describe 'draw?' do
    it 'returns true if difference <= 5' do
      expect(battle.draw?(2, 4)).to be true
    end

    it 'returns false if difference > 5' do
      expect(battle.draw?(2, 8)).to be false
    end
  end

  describe 'check_winner' do
    it 'returns [false, 0] if its a draw' do
      battle.update(draw: true)
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
end