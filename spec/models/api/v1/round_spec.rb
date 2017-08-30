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

      describe "scope(self.partials)" do
        before do
          season = FactoryGirl.create(:season)
          @round = FactoryGirl.create(:round, season: season,
            dispute_month: FactoryGirl.create(:dispute_month, season: season ))
        end
      end
    end
  end
end
