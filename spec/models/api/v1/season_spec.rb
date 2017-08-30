require "rails_helper"

module Api
  module V1
    RSpec.describe Season, :type => :model do

      describe "Validations" do
        it { should have_many(:dispute_months) }
        it { should have_many(:rounds) }
        it { should have_many(:scores ) }
        it { should validate_presence_of(:year) }
      end

      describe "Serialization" do
        let (:season ) { FactoryGirl.create(:season) }
        it "Should serialize golden rounds" do
          season.golden_rounds = [1,2,3,4,5]
          season.save
          expect(season.golden_rounds.class).to eq(Array)
          expect(season.golden_rounds.first).to eq(1)
        end
      end
    end
  end
end
