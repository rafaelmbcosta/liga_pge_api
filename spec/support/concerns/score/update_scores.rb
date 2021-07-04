require 'rails_helper'

shared_examples 'update_scores' do

  before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.clean
    allow(TeamWorker).to receive(:perform_now).and_return(true)
  end

  let(:team) { FactoryBot.create(:team, id_tag: 1, active: true) }
  let(:season) { FactoryBot.create(:season, year: Time.now.year) }
  let(:round) { season.rounds.take }

  describe 'update_scores' do
    before do
      allow(Team).to receive(:active).and_return([team])
      allow(Score).to receive(:update_team_scores).and_return(true)
    end

    it 'returns true if all scores are updated' do
      expect(Score.update_scores(round)).to be true
    end
  end

  describe 'update_team_scores' do
    let(:data) { { 'pontos' => 78.2 } }
    let(:score) { FactoryBot.create(:score, team: team, round: round, final_score: nil) }

    before do
      allow(Score).to receive(:find_by).and_return(score)
    end

    it "raises 'Invalid API Scores' if it fails to connect" do
      allow(Connection).to receive(:team_score).and_return(nil)
      expect { Score.update_team_scores(round, team) }.to raise_error('Invalid API Scores')
    end

    it 'updates the score with the data from API' do
      allow(Connection).to receive(:team_score).and_return(data)
      Score.update_team_scores(round, team)
      expect(score.final_score).to eq(78.2)
    end
  end
end