require 'rails_helper'

RSpec.describe NewBattlesWorker do

  before(:each) do
    allow(Battle).to receive(:create_battles).and_return('create_battles')
    allow(Battle).to receive(:show_battles).and_return('show_battles')
  end

  describe 'creating battles' do
    it 'return true if all battles created' do
      expect(NewBattlesWorker.perform_now(nil)).to eq 'create_battles'
    end
  end
end