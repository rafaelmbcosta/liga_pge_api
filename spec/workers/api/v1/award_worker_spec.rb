require 'rails_helper'

module Api
  module V1
    RSpec.describe AwardWorker do

      before do
        ::DatabaseCleaner.start
        ::DatabaseCleaner.clean
        @season = Season.create(year: 2018, finished: false)
        @dipute_month = FactoryBot.build(:v1_dispute_month, season_id: @season.id)
        @round = FactoryBot.build(:v1_round, season_id: @season.id, dispute_month: @dispute_month)
        @round.save
        @season.stubs(:first_half_prize).returns([50, 30, 20])
        @teams = FactoryBot.build_list(:v1_team, 33, season_id: @season.id)
        # Making the association
        @teams.each do |team|
          player = FactoryBot.build(:v1_player)
          score = FactoryBot.build(:v1_score)
        end
      end

      describe "Scope 'award_first_turn'" do
        it 'Should create 3 awards if less than 35 teams' do
          raise Season.all.inspect
          expect(true).to eq(true)
        end
      end
    end
  end
end
