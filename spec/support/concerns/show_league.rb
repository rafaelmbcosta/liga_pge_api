require 'rails_helper'

module Api
  module V1
    shared_examples 'show_league' do
      let(:model) { described_class }

      describe 'show_league' do
        let(:season) { FactoryBot.create(:v1_season) }
        let(:dispute_month) { FactoryBot.create(:v1_dispute_month, season: season) }

        before do
          season.dispute_months << dispute_month
          allow(Season).to receive(:active).and_return(season)
          allow(model).to receive(:dispute_month_league_report).and_return(status: 'ok')
        end

        it 'saves all results to redis' do
          expect(model.show_league).to eq([{ status: 'ok' }])
        end
      end
    end
  end
end
