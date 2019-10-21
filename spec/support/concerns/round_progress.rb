require 'rails_helper'

module Api
  module V1
    shared_examples 'round_progress' do
      describe 'progress' do

      end

      describe 'step_complete?' do
        let(:season) { FactoryBot.create(:v1_season) }
        let(:dispute_month) { FactoryBot.create(:v1_dispute_month, season: season) }
        let(:round) { FactoryBot.create(:v1_round, season: season, dispute_month: dispute_month) }
        let(:finished_step) { { attribute: :finished, label: 'rodada finalizada', round: true } }
        let(:round_control) { FactoryBot.create(:v1_complete_round_control, round: round) }
        let(:market_closed_step) { { attribute: :market_closed, label: 'mercado fechado', round: false } }
        let(:battles_generated_step) { { attribute: :battles_generated, label: 'batalhas criadas', round: false } }
        let(:scores_created_step) { { attribute: :scores_created, label: 'placares criados', round: false } }
        let(:scores_updated_step) { { attribute: :scores_updated, label: 'placares atualizados', round: false } }
        let(:battle_scores_updated_step) { { attribute: :battle_scores_updated, label: 'confrontos atualizados', round: false } }
        let(:currencies_generated_step) { { attribute: :currencies_generated, label: 'premiação criada', round: false } }

        before do
          season.dispute_months << dispute_month
          round.dispute_month = dispute_month
          round.round_control = round_control
        end

        it 'returns true if the round step is complete' do
          round.finished = true
          expect(round.step_complete?(finished_step)).to be true
        end

        it 'returns true if the round control step is complete' do
          expect(round.step_complete?(market_closed_step)).to be true
          expect(round.step_complete?(battles_generated_step)).to be true
          expect(round.step_complete?(scores_created_step)).to be true
          expect(round.step_complete?(scores_updated_step)).to be true
          expect(round.step_complete?(battle_scores_updated_step)).to be true
          expect(round.step_complete?(currencies_generated_step)).to be true
        end

        it 'returns false if it doesnt' do
          round_control.scores_updated = false
          expect(round.step_complete?(scores_updated_step)).to be false
        end
      end
    end
  end
end