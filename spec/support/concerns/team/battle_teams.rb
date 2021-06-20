require 'rails_helper'

shared_examples 'battle_teams' do
  before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  describe 'ghost_needed?' do
    let(:team) { Team.create(name: 'team-1', id_tag: '123', active: true) }
    let(:team_2) { Team.create(name: 'team-2', id_tag: '456', active: true) }

    it 'returns true if numbers are odd' do
      allow(Team).to receive(:active).and_return([team])
      expect(Team.ghost_needed?).to be true
    end

    it 'returns false if numbers are even' do
      allow(Team).to receive(:active).and_return([team, team_2])
      expect(Team.ghost_needed?).to be false
    end
  end

  describe 'new_battle_teams' do
    let(:team) { Team.create(name: 'team-1', id_tag: '123', active: true) }
    let(:team_2) { Team.create(name: 'team-2', id_tag: '456', active: true) }


    it 'returns active teams if no ghost needed' do
      allow(Team).to receive(:active).and_return([team, team_2])
      expect(Team.new_battle_teams).to eq([team, team_2])
    end

    it 'returns active teams plus nil if needed' do
      allow(Team).to receive(:active).and_return([team])
      expect(Team.new_battle_teams).to eq([team, nil])
    end
  end
end