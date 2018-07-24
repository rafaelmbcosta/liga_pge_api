require 'rails_helper'

module Api
  module V1
    RSpec.describe MonthActivity, type: :model do

      describe 'Associations' do
        it { should belong_to :team }
        it { should belong_to :dispute_month }
      end

      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean

        @season = FactoryBot.create(:v1_season)
        @dispute = FactoryBot.create(:v1_dispute_month, season: @season)
        @round = FactoryBot.create(:v1_round, season: @season, dispute_month: @dispute)
        @player = FactoryBot.create(:v1_player)
        @team = FactoryBot.create(:v1_team, season: @season, player: @player)
        @month_activity = MonthActivity.create(active: true, payed: true, payed_value: 0,
          team: @team, dispute_month: @dispute)
      end

      describe "Scope 'pay'" do
        it "should set the value" do
          @month_activity.pay(24)
          expect(@month_activity.payed_value).to eq(24)
        end
      end
    end
  end
end
