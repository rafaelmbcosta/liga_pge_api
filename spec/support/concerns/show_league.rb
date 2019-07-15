require 'rails_helper'

module Api
  module V1
    shared_examples 'show_league' do
      let(:model) { described_class }
      let(:season) { FactoryBot.create(:v1_season) }
      let(:dispute_month) { FactoryBot.create(:v1_dispute_month, season: season) }

      describe 'show_league' do

        before do
          season.dispute_months << dispute_month
          allow(Season).to receive(:active).and_return(season)
          allow(model).to receive(:dispute_month_league_report).and_return(status: 'ok')
        end

        it 'saves all results to redis' do
          expect(model.show_league).to eq([{ status: 'ok' }])
        end
      end

      describe 'dispute_month_league_report' do
        let(:expectation) { { name: dispute_month.name, id: dispute_month.id, players: [] } }
        let(:team) { FactoryBot.create(:v1_team) }
        let(:opponent) { FactoryBot.create(:v1_team) }

        before do
          allow(model).to receive(:league_report_teams).and_return([])
        end

        it 'Returns the hash with all players' do
          expect(model.dispute_month_league_report(dispute_month, [team])).to eq(expectation)
        end
      end

      describe 'opponent' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:opponent) { FactoryBot.create(:v1_team) }
        let(:battle) { Battle.new(first_id: team.id, second_id: opponent.id) }
        let(:teams) { [team, opponent] }

        it 'returns the other second team' do
          allow(teams).to receive(:find).and_return(opponent)
          expect(model.opponent(battle, team, teams)).to eq(opponent.name)
        end

        it 'returns ghost if second team is nil' do
          battle.second_id = nil
          expect(model.opponent(battle, team, teams)).to eq('Fantasma')
        end
      end
    end
  end
end
