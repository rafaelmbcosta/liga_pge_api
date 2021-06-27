require 'rails_helper'

shared_examples 'show_league' do
  before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  let(:season) { FactoryBot.create(:season, year: Time.now.year) }
  let(:team) { FactoryBot.create(:team, id_tag: 1) }
  let(:dispute_month) { FactoryBot.create(:dispute_month, season: season) }
  let(:round) { season.rounds.first }
  let(:team) { FactoryBot.create(:team, id_tag: 1) }
  let(:rival) { FactoryBot.create(:team, id_tag: 2) }
  let(:battle) { Battle.create(round: round, first_id: team.id, second_id: rival.id) }
  let(:teams) { [team] }

  before do
    round.update(dispute_month: dispute_month)
    round.battles << battle
    dispute_month.rounds << round
  end

  describe 'show_league' do
    it 'should return a structured data' do
      allow(season).to receive(:dispute_months).and_return([dispute_month])
      allow(Battle).to receive(:dispute_month_league_report).and_return({ name: 'player_name' })
      allow(Team).to receive(:all).and_return(teams)
      expect(Battle.show_league).to eq([{ name: 'player_name'}])
    end
  end

  describe 'dispute_month_league_report' do
    before do
      allow(Battle).to receive(:league_report_teams).and_return({team: 'team_name'})
      allow(Battle).to receive(:sort_league_report).and_return({team: 'team_name'})
    end

    it 'returns the structured dispute month' do
      expect(Battle.dispute_month_league_report(dispute_month, teams)).to eq({ id: dispute_month.id, name: dispute_month.name, players: { team: 'team_name'} })
    end
  end

  describe 'opponent' do
    let(:teams) { [team, rival] }
    it 'should return the opponent if both are players' do
      expect(Battle.opponent(battle, team, teams)).to eq(rival.name)
    end

    it 'should return a ghost if oponnent id is nil' do
      battle.second_id = nil
      expect(Battle.opponent(battle, team, teams)).to eq('Fantasma')
    end
  end

  describe 'check_victory' do
    it 'returns if its a victory and the difference points' do
      allow(battle).to receive(:team_victory).and_return(true)
      allow(battle).to receive(:team_difference_points).and_return(29)
      expect(Battle.check_victory(battle, team)).to eq([true, [3, 29]])
    end

    it 'returns [false, []] if its a loss' do
      allow(battle).to receive(:team_victory).and_return(false)
      expect(Battle.check_victory(battle, team)).to eq([false, []])
    end
  end

  describe 'league_battle_result' do
    it 'returns [1, 0] if its a draw' do
      battle.update(draw: true)
      expect(Battle.league_battle_result(battle, team)).to eq([1, 0])
    end

    it 'returns [3, 0] if victory' do
      battle.update(draw: false)
      allow(Battle).to receive(:check_victory).and_return([true, [3, 79]])
      expect(Battle.league_battle_result(battle, team)).to eq([3, 79])
    end

    it 'returns [0, 0] if its a loss' do
      battle.update(draw: false)
      allow(Battle).to receive(:check_victory).and_return([false, nil])
      expect(Battle.league_battle_result(battle, team)).to eq([0, 0])
    end
  end

  describe 'team_difference_points' do
    it 'returns the absolute difference' do
      battle.update(first_points: 20, second_points: 10)
      expect(battle.team_difference_points).to eq(10)
      battle.update(first_points: 5, second_points: 15)
      expect(battle.team_difference_points).to eq(10)
    end
  end
end