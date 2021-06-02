require "rails_helper"

RSpec.describe Season, :type => :model do
  before do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  describe "Validations" do
    it { should have_many(:dispute_months) }
    it { should have_many(:rounds) }
    it { should have_many(:scores) }
    it { should validate_presence_of(:year) }
  end

  describe 'only_one_active after create hook' do
    let(:seasons) { [
      { year: 2020, finished: false},
      { year: 2021, finished: false}
    ] }

    it 'dont raise any error if ok' do
      expect(Season.create(seasons.first)).to be_instance_of Season
    end

    it 'raise error if there is another active' do
      expect{ Season.create(seasons) }.to raise_error 'Season already exist'
    end
  end

  describe 'new_season' do
    it 'creates season and rounds' do
      season = Season.new_season
      expect(season.rounds.count).to eq(38)
    end
  end
end
