require "rails_helper"

module Api
  module V1
    RSpec.describe Season, :type => :model do
      it_behaves_like 'turns_and_championship'

      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean

        @season = FactoryBot.create(:v1_season, year: 2018) if @season.nil?
        @dispute_month = FactoryBot.create(:v1_dispute_month, season: @season)
      end

      describe "Validations" do
        it { should have_many(:dispute_months) }
        it { should have_many(:rounds) }
        it { should have_many(:scores) }
        it { should validate_presence_of(:year) }
      end

      describe "'another_season_active?' validation" do
        it 'should now allow two active seasons' do
          @another_season = Season.new(year: 2019, finished: false)
          @another_season.save
          expect(@another_season.errors.messages).to include(:already_exist)
        end
        it 'should allow current active season to finish' do
          @season.finished = true
          expect(@season.save).to be true
        end
      end

      describe 'active_rounds' do
        it 'should return all rounds not finished' do
          FactoryBot.create_list(:v1_round, 2, finished: false, dispute_month: @dispute_month,
                                 season: @season)
          expect(@season.active_rounds.count).to eq(2)
        end
      end
    end
  end
end
