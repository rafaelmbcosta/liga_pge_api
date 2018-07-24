require "rails_helper"

module Api
  module V1
    RSpec.describe Season, :type => :model do

      describe "Validations" do
        it { should have_many(:dispute_months) }
        it { should have_many(:rounds) }
        it { should have_many(:scores) }
        it { should validate_presence_of(:year) }
      end

      describe "Serialization" do
        let (:season) { FactoryBot.create(:v1_season) }
        it "Should serialize golden rounds" do
          season.golden_rounds = [1,2,3,4,5]
          season.save
          expect(season.golden_rounds.class).to eq(Array)
          expect(season.golden_rounds.first).to eq(1)
        end
      end

      describe "Scopo 'cash'" do

        before do
          DatabaseCleaner.start
          DatabaseCleaner.clean

          @season = FactoryBot.create(:v1_season)
          @dispute = FactoryBot.create(:v1_dispute_month, season: @season)
          @round = FactoryBot.create(:v1_round, season: @season, dispute_month: @dispute)
          @player = FactoryBot.create(:v1_player)
          @team = FactoryBot.create(:v1_team, season: @season, player: @player)
        end

        it "Return 0 if no payments" do
          expect(@season.cash).to eq(0)
        end

        it "returns the sum of all payments" do
          MonthActivity.create(active: true, payed: true, payed_value: 12,
            team: @team, dispute_month: @dispute)
          expect(@season.cash).to eq(12)
        end

        it "should return 'payments - rewards'" do
          MonthActivity.create(active: true, payed: true, payed_value: 12,
            team: @team, dispute_month: @dispute)
          Award.create(award_type: 1, dispute_month: @dispute, team: @team,
            season: @season, prize: 8, payed: true)
          # 12 - 8
          expect(@season.cash).to eq(4)
        end
      end
    end
  end
end
