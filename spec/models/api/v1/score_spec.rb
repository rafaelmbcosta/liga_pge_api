require 'rails_helper'

module Api
  module V1
    RSpec.describe Score, type: :model do
      let(:season) { FactoryBot.create(:v1_season, year: 2019) }

      let(:dispute_month) do
        return FactoryBot.create(:v1_dispute_month, season: season,
                                                    dispute_rounds: (10..20).to_a)
      end

      let(:round) do
        return FactoryBot.create(:v1_round, number: 11, finished: false, season: season,
                                            dispute_month: dispute_month)
      end

      let(:round_control) { RoundControl.create(round: round) }

      let(:team) { Team.create(slug: 'time-fc', name: 'Time-FC', active: true) }

      before do
        allow(Team).to receive(:active).and_return([team])
        round.round_control = round_control
      end

      describe 'create_scores_rounds' do
        let(:rounds) { FactoryBot.build_list(:v1_round, 2) }

        it 'return array of rounds if any match condititons' do
          allow(Round).to receive(:avaliable_for_score_generation).and_return(rounds)
          expect(Score.create_scores_rounds).to eq(rounds)
        end

        it 'returns empty array if no round match conditions' do
          allow(Round).to receive(:avaliable_for_score_generation).and_return([])
          expect(Score.create_scores_rounds).to eq([])
        end
      end

      describe 'create_scores' do
        it 'returns true if no error is caught' do
          allow(Score).to receive(:create_scores_rounds).and_return([round])
          expect(Score.create_scores).to be true
        end

        it 'return flow control in case of error' do
          invalid_round = Round.new
          allow(Score).to receive(:create_scores_rounds).and_return([invalid_round])
          expect(Score.create_scores).to be_instance_of(FlowControl)
        end
      end

      describe 'create_scores_round' do
        it 'update scores_created to true' do
          Score.create_scores_round(round)
          expect(round.round_control.scores_created).to be true
        end

        it 'creates scores for the teams' do
          Score.create_scores_round(round)
          expect(Score.where(round: round)).not_to be_empty
        end

        it 'returns true' do
          expect(Score.create_scores_round(round)).to be true
        end
      end
    end
  end
end
