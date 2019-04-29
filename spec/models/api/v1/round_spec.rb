require 'rails_helper'

module Api
  module V1
    RSpec.describe Round, type: :model do
      describe "Relationship" do
        it { should belong_to :season }
        it { should belong_to :dispute_month }
        it { should have_many :scores }
        it { should have_many :battles }
      end

      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean

        @season = FactoryBot.create(:v1_season, year: 2019)
        @dispute_month = FactoryBot.create(:v1_dispute_month, season: @season)
      end

      describe 'validate uniqueness of name in season' do
        it 'should raise error when creating duplicates' do
          FactoryBot.create(:v1_round, number: 11, season: @season, 
                            dispute_month: @dispute_month)
          round = FactoryBot.build(:v1_round, number: 11, season: @season, 
                                   dispute_month: @dispute_month,)
          expect{ round.save! }.to raise_error(ActiveRecord::RecordInvalid, 
                                              'Validation failed: Number Rodada já existente na temporada')
        end 
      end

      describe 'validates_more_than_two' do
        it 'should allow even two rounds active per season' do
          FactoryBot.create_list(:v1_round, 2, finished: false, season: @season, 
                                 dispute_month: @dispute_month)
          expect(@season.active_rounds.count).to eq(2)
        end
      end

      describe 'self.exist_round?' do
        it 'should return true if it exists' do
          round = FactoryBot.create(:v1_round, finished: false, season: @season, 
                            dispute_month: @dispute_month, number: 13)
          expect(Round.exist_round?(@season, 13)).to be true
        end
      end

      describe 'check_new_round' do
        it 'expect to raise error unless current round is a number' do
          Season.stubs(:active).returns(@season)
          Connection.stubs(:current_round).returns(nil)
          Round.stubs(:exist_round?).returns(true)
          expect { Round.check_new_round }.to raise_error(RuntimeError)
        end

        it 'expect to return true round already exist' do
          Round.stubs(:exist_round?).returns(13)
          expect(Round.check_new_round).to be true
        end

        it 'expect to return the newly created round' do 

          Round.unstub(:exist_round?)
          Season.unstub(:active)
          Connection.unstub(:current_round)
        end
      end
      
      describe 'new_round' do
        it 'should return the newly created round if allowed' do
          expect(Round.new_round(13).number).to be(13)
        end

        it 'should raise error if round is invalid' do

        end
      end
    end
  end
end
