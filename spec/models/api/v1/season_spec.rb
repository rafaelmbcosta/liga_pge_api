require "rails_helper"

module Api
  module V1
    RSpec.describe Season, :type => :model do

      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean

        @season = Season.current
        @season = FactoryBot.create(:v1_season) if @season.nil?
      end

      describe "Validations" do
        it { should have_many(:dispute_months) }
        it { should have_many(:rounds) }
        it { should have_many(:scores) }
        it { should validate_presence_of(:year) }
      end

      describe "'another_season_active?' validation" do
        it 'Should check if there is another active season' do
          @another_season = Season.new
          @another_season.save
          expect(@another_season.errors.messages).to include(:already_exist)
        end
      end

      describe "Serialization" do
        it "Should serialize golden rounds" do
          @season.golden_rounds = [1,2,3,4,5]
          @season.save
          expect(@season.golden_rounds.class).to eq(Array)
          expect(@season.golden_rounds.first).to eq(1)
        end
      end

      describe 'Total Money' do
        it 'should sum all total_prizes' do
          dispute_month = DisputeMonth.create(season: @season, name: 'Janeiro')
          dispute_month.stubs(:prize_pool).returns(5)
          @season.dispute_months << dispute_month
          expect(@season.total_money).to eq(5)
        end
      end

      describe "Scopo 'cash'" do

        # before do
        #   DatabaseCleaner.start
        #   DatabaseCleaner.clean
        #
        #   @season = FactoryBot.create(:v1_season)
        #   @dispute = FactoryBot.create(:v1_dispute_month, season: @season)
        #   @round = FactoryBot.create(:v1_round, season: @season, dispute_month: @dispute)
        #   @player = FactoryBot.create(:v1_player)
        #   @team = FactoryBot.create(:v1_team, season: @season, player: @player)
        # end
        #
        # it "Return 0 if no payments" do
        #   expect(@season.cash).to eq(0)
        # end
        #
        # it "returns the sum of all payments" do
        #   MonthActivity.create(active: true, payed: true, payed_value: 12,
        #     team: @team, dispute_month: @dispute)
        #   expect(@season.cash).to eq(12)
        # end
        #
        # it "should return 'payments - rewards'" do
        #   MonthActivity.create(active: true, payed: true, payed_value: 12,
        #     team: @team, dispute_month: @dispute)
        #   Award.create(award_type: 1, dispute_month: @dispute, team: @team,
        #     season: @season, prize: 8, payed: true)
        #   # 12 - 8
        #   expect(@season.cash).to eq(4)
        # end
      end
    end
  end
end
