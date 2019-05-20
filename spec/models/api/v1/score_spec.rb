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

      describe 'update_scores' do
        it 'returns flow control if something goes wrong' do
          invalid_round = Round.new
          allow(Score).to receive(:rounds_with_scores_to_update).and_return([invalid_round])
          expect(Score.update_scores).to be_instance_of(FlowControl)
        end

        let(:valid_round) do
          FactoryBot.create(:v1_round, finished: true, number: 15,
                                       dispute_month: dispute_month,
                                       season: season)
        end
        let(:round_control) do
          round_control = RoundControl.create(round: valid_round,
                                              scores_created: true,
                                              scores_updated: false,
                                              updating_scores: false)
        end

        before do
          valid_round.round_control = round_control
          allow(Score).to receive(:rounds_with_scores_to_update).and_return([valid_round])
          allow(Connection).to receive(:team_score).and_return({ 'pontos' => 20 })
          Score.create(team: team, round: valid_round)
        end

        it 'update round control updated_scores to true' do
          Score.update_scores
          expect(valid_round.round_control.scores_updated).to be true
        end

        it 'returns true if success' do
          expect(Score.update_scores).to be true
        end
      end

      describe 'rounds_with_scores_to_update' do
        let(:round_with_scores_to_update) do 
          FactoryBot.create(:v1_round, finished: true, number: 15,
                                       dispute_month: dispute_month,
                                       season: season)
        end

        it 'bring rounds with conditions' do
          round_control = RoundControl.create(round: round_with_scores_to_update,
                                              scores_created: true,
                                              scores_updated: false,
                                              updating_scores: false)
          round_with_scores_to_update.round_control = round_control
          expect(Score.rounds_with_scores_to_update).to eq([round_with_scores_to_update])
        end

        it 'return empty array if no round meets condition' do
          expect(Score.rounds_with_scores_to_update).to be_empty
        end
      end

      describe 'show_scores' do
        let()
        it 'return hash with the results grouped by dispute_month' do

        end
      end

      describe 'player_details' do
        let(:scores) { }
      end
    end
  end
end
