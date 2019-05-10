require 'rails_helper'
module Api
  module V1
    RSpec.describe RoundWorker do
      before do
        RoundWorker.stubs(:check_new_round).returns(true)
        Round.stubs(:check_new_round).returns(true)
      end

      describe 'self.perform' do
        it 'return check_new_round return' do
          expect(RoundWorker.perform).to be true
        end
      end

      describe 'self.check_new_round' do
        it 'returns whatever Round.checkround returns' do
          RoundWorker.unstub(:check_new_round)
          expect(RoundWorker.check_new_round).to eq(true)
        end
      end

      after do
        RoundWorker.unstub(:check_new_round)
        Round.unstub(:check_new_round)
      end
    end
  end
end
