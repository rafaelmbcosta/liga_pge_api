require 'rails_helper'

RSpec.describe BattleWorker do

  describe 'creating battles' do
    it 'return true if all battles created' do
      allow(Battle).to receive(:create_battles).and_return(true)
      expect(BattleWorker.create_battles).to be true
    end
  end
end