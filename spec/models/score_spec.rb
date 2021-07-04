require 'rails_helper'

RSpec.describe Score, type: :model do
  it_behaves_like 'update_scores'
  it_behaves_like 'show_scores'

  describe 'create_scores' do
    let(:team) { FactoryBot.create(:team, id_tag: 1, active: true) }
    let(:season) { FactoryBot.create(:season, year: Time.now.year) }
    let(:round) { season.rounds.take }

    before(:each) do
      DatabaseCleaner.start
      DatabaseCleaner.clean
    end

    it 'return true if all scores are created' do
      allow(Team).to receive(:active).and_return([team])
      expect(Score.create_scores(round)).to eq(true)
    end
  end
end
