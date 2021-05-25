require 'rails_helper'

RSpec.describe RoundWorker do
  describe 'self.close_market' do
    it 'return true if market is just closed' do
      allow(Round).to receive(:close_market).and_return(true)
      expect(RoundWorker.close_market).to be true
    end

    it 'return false if market is not closed' do
      allow(Round).to receive(:close_market).and_return(false)
      expect(RoundWorker.close_market).to be false
    end
  end

  describe 'self.check_new_round' do
    it 'return whathever Round.check_new_round gets' do
      allow(Round).to receive(:check_new_round).and_return(false)
      expect(RoundWorker.check_new_round).to be false
    end
  end
end
