require 'rails_helper'

module Api
  module V1
    RSpec.describe Award, type: :model do
      describe "Relationship" do
        it { should belong_to :dispute_month }
        it { should belong_to :team }
        it { should belong_to :season }
      end

      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean

        @season = FactoryBot.create(:v1_season)
        @dispute = FactoryBot.create(:v1_dispute_month, season: @season)
        @round = FactoryBot.create(:v1_round, season: @season, dispute_month: @dispute)
        @player = FactoryBot.create(:v1_player)
        @team = FactoryBot.create(:v1_team, season: @season, player: @player)
      end

      describe "Scopo 'pay_award'" do
        it "pay_award sets payed 'true'" do
          award = Award.create(award_type: "golden", dispute_month: @dispute_month,
              team: @team, position: 1, season: @season, prize: 50, round: @round, payed: false)
          award.pay_award

          expect(award.payed).to eq(true)
        end

      end
    end
  end
end
