require 'rails_helper'

shared_examples 'creation' do
  before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  describe 'create_battles' do
    let(:team) { FactoryBot.create(:team, id_tag: '123') }

    it 'return true if battles succefully generated' do
      allow(Battle).to receive(:sort_battle).and_return(true)
      expect(Battle.create_battles(nil)).to be true
    end

    it 'raise an error if battles are odd' do
      allow(Team).to receive(:new_battle_teams).and_return([team])
      expect { Battle.create_battles(nil) }.to raise_error('cannot generate battle with ODD teams')
    end
  end

  describe 'sort_battle' do
    let(:p1) { FactoryBot.create(:team, id_tag: 1) }
    let(:p2) { FactoryBot.create(:team, id_tag: 2) }
    let(:p3) { FactoryBot.create(:team, id_tag: 3) }
    let(:teams) { [p1, p2, p3] }
    let(:season) { FactoryBot.build(:season, year: 2019) }
    let(:round) { FactoryBot.build(:round, number: 11, season: season) }

    it 'returns empty array if success' do
      expect(Battle.sort_battle(teams, round)).to eq([])
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

  describe 'pick_team' do
    let(:teams) { (1..5).to_a }

    it 'removes a team from the list and return it' do
      expect(teams).not_to include(Battle.pick_team(teams)[0])
    end

    it 'returns teams with one less team' do
      expect(Battle.pick_team(teams)[1].size).to eq(4)
    end
  end

  describe 'lower_battle_number' do
    it 'returns the lower number' do
      history = { 'p1' => 4, 'p2' => 4, 'p3' => 3, 'p4' => 3 }
      expect(Battle.lower_battle_number(history)).to eq(3)
    end
  end

  describe 'check_encounters' do
    let(:p1) { FactoryBot.create(:team, id_tag: 1) }
    let(:p2) { FactoryBot.create(:team, id_tag: 2) }
    let(:p3) { FactoryBot.create(:team, id_tag: 3) }
    let(:teams) { [p2, p3] }
    let(:round) { FactoryBot.build(:round, number: 11) }

    it 'returns the battle history of the chosen team' do
      Battle.create(first_id: p1.id, second_id: p2.id, round: round)
      expected_result = { p2 => 1, p3 => 0 }
      expect(Battle.check_encounters(p1, teams, round)).to eq(expected_result)
    end
  end

  describe 'create_battle' do
    let(:team) { FactoryBot.create(:team, id_tag: 1) }
    let(:rival) { FactoryBot.create(:team, id_tag: 2) }
    let(:round) { FactoryBot.build(:round, number: 11) }

    it 'create a battle' do
      expect(Battle.create_battle(team, rival, round)).to be_instance_of(Battle)
    end
  end
end