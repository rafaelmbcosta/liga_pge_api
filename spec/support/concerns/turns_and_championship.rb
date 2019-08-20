require 'rails_helper'

module Api
  module V1
    shared_examples 'turns_and_championship' do
      let(:model) { described_class }
      let(:season) { FactoryBot.build(:v1_season) }
      let(:team) { FactoryBot.build(:v1_team) }

      describe 'turns_and_championship' do
        before do
          allow(Api::V1::Season).to receive(:active).and_return(season)
          allow(Api::V1::Team).to receive(:all).and_return([team])
          allow(model).to receive(:range_scores).and_return([])
        end

        it 'return season_scores' do
          expect(model.turns_and_championship).to eq('OK')
        end
      end

      describe 'range_scores' do
        let(:round) { FactoryBot.build(:v1_round, number: 1) }
        let(:score) { FactoryBot.build(:v1_score) }
        let(:no_score_expectation) { { title: 'Primeiro Turno', scores: [] } }
        let(:score_expectation) { { title: 'Primeiro Turno', scores: { team_id: 1, team_name: 'hello' } } }
        let(:data) { { title: 'Primeiro Turno', range: 1..18 } }

        it 'returns hash with empty scores if no score matches' do
          expect(model.range_scores(data, [team], [])).to eq(no_score_expectation)
        end

        it 'returns hash with turn or championship details' do
          allow(score).to receive(:round).and_return(round)
          allow(score).to receive(:select).and_return([score])
          allow(model).to receive(:team_score_data).and_return(team_id: 1, team_name: 'hello')
          expect(model.range_scores(data, [team], [score])).to eq(score_expectation)
        end
      end
    end
  end
end
