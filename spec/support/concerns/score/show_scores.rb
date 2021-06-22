require 'rails_helper'

shared_examples 'show_scores' do

  before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.clean
    # allow(TeamWorker).to receive(:perform).and_return(true)
  end

  let(:team) { FactoryBot.create(:team, id_tag: 1, active: true) }
  let(:season) { FactoryBot.create(:season, year: Time.now.year) }
  let(:dispute) { FactoryBot.create(:dispute_month, season: season) }
  let(:round) { season.rounds.first }
  let(:round_2) { season.rounds.second }
  let(:teams) { [team] }
  let(:score_a) { Score.create(round: round, final_score: 10, team: team) }
  let(:score_b) { Score.create(round: round_2, final_score: 5, team: team) }

  before do
    allow(Team).to receive(:active).and_return([team])
    allow(Season).to receive(:active).and_return(season)
    allow(season).to receive(:dispute_months).and_return([dispute])
    round.scores << score_a
    round_2.scores << score_b
    dispute.rounds << round
    dispute.rounds << round_2
  end

  describe 'show_scores' do
    let(:scores) { [score_a] }

    let(:expectation) do
      return [
        {
          name: dispute.name,
          id: dispute.id,
          players: [{ round: round.number, points: 10.0 }]
        }
      ]
    end

    it 'return a json with the data' do
      allow(Score).to receive(:dispute_months_players).and_return([{ round: round.number, points: 10.0 }])
      expect(Score.show_scores).to eq(expectation)
    end
  end

  describe 'dispute_months_players' do
    let(:scores) do
      return [
        Score.create(round: round, final_score: 10, team: team),
        Score.create(round: round_2, final_score: 5, team: team)
      ]
    end

    let(:team_details) do
      return [{ round: round.number, points: 10.0 },
              { round: round_2.number, points: 5.0 }]
    end

    let(:expectation) do
      return [
        {
          name: team.player_name,
          team: team.name,
          team_symbol: team.url_escudo_png,
          details: team_details,
          points: 15.0
        }
      ]
    end

    before do
      allow(Score).to receive(:team_details).and_return(team_details)
    end

    it 'return list of teams with their scores' do
      expect(Score.dispute_months_players(dispute.scores, [team])).to eq(expectation)
    end
  end

  describe 'order_dispute_months' do
    let(:original_array) { [{ id: '1' }, { id: '3' }, { id: '2' }] }
    let(:expected_array) { [{ id: '3' }, { id: '2' }, { id: '1' }] }

    it 'return the same hash ordered by id' do
      expect(Score.order_dispute_months(original_array)).to eq(expected_array)
    end
  end

  describe 'order_players' do
    let(:unordered_players) { [{ points: 3 }, { points: 7 }, { points: 5 }] }
    let(:ordered_players) { [{ points: 7 }, { points: 5 }, { points: 3 }] }

    it 'return array ordered by points' do
      expect(Score.order_players(unordered_players)).to eq(ordered_players)
    end
  end

  describe 'team_details' do
    let(:scores) { [score_a, score_b] }

    let(:expectation) do
      return [{ round: round.number, points: 10.0 },
              { round: round_2.number, points: 5.0 }]
    end

    it 'list team scores for each round' do
      expect(Score.team_details(team, dispute.scores)).to eq(expectation)
    end
  end
end