require 'rails_helper'

module Api
  module V1
    RSpec.describe MonthActivity, type: :model do
      describe 'Associations' do
        it { should belong_to :team }
        it { should belong_to :dispute_month }
      end

    end
  end
end
