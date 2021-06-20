require 'rails_helper'

shared_examples 'show_battles' do
  before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  let(:season) { Season.create(year: Time.now.year) }
  let(:round) { season.rounds.take }
  let(:team) { FactoryBot.create(:team, id_tag: 1) }
  let(:rival) { FactoryBot.create(:team, id_tag: 2) }
  let(:battle) { Battle.create(round: round, first_id: team.id, second_id: rival.id) }


  describe 'show_battles' do
    it 'builds the battle service' do
      allow(Battle).to receive(:battles_to_be_shown).and_return([battle])
      allow(Team).to receive(:all).and_return([team, rival])
      allow(Battle).to receive(:battle_report).and_return([])
      allow(Battle).to receive(:order_battle_report).and_return([])
      expect(Battle.show_battles).to be_empty
    end
  end

  describe 'battles_to_be_shown' do
    before do
      allow(Battle).to receive(:where).and_return([battle])
    end

    it 'returns all battles where season is active' do
      expect(Battle.battles_to_be_shown).to eq(round.id => [battle])
    end
  end

  describe 'battle_report' do
    let(:expectation) do
      return [
        { battles: [], round: round.number }
      ]
    end

    it 'return a list of battle groups' do
      allow(Battle).to receive(:show_list_battles).and_return([])
      expect(Battle.battle_report({ round.id => [battle] }, [team, rival])).to eq(expectation)
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

   describe 'show_list_battles' do
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

  describe 'show_battle_data' do
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

  describe 'battle_team_details' do
    let(:team) { FactoryBot.create(:team, id_tag: 1, id: 1) }
    let(:teams) { [nil, team] }

    it 'returns ghost details if team id is nil' do
      expect(Battle.battle_team_details(nil, teams)).to eq(['Fantasma', ''])
    end

    it 'returns name and symbol of the corresponding team' do
      allow(teams).to receive(:find).and_return(team)
      expect(Battle.battle_team_details(1, teams)).to eq(["#{team.player_name} ( #{team.name} )", team.url_escudo_png])
    end
  end
end