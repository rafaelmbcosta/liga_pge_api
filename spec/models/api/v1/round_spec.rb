require 'rails_helper'

module Api
  module V1
    RSpec.describe Round, type: :model do
      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean
        # allow(Round).to receive(:find_dispute_month).and_return(dispute_month)
      end

      let(:season) { FactoryBot.create(:v1_season, year: 2019) }

      let(:dispute_month) do
        return FactoryBot.create(:v1_dispute_month, season: season,
                                                    dispute_rounds: (10..20).to_a)
      end
      let(:data) do
        return {
          'fechamento' => {
            'ano' => 2019, 'mes' => 1,
            'dia' => 1, 'hora' => 14, 'minuto' => 0
          },
          'rodada_atual' => 14,
          'status_mercado' => 1
        }
      end

      describe 'Relationship' do
        it { is_expected.to belong_to :season }
        it { is_expected.to belong_to :dispute_month }
        it { is_expected.to have_many :scores }
        it { is_expected.to have_many :battles }
      end

      describe 'validate uniqueness of name in season' do
        it 'raise error when creating duplicates' do
          FactoryBot.create(:v1_round, number: 11, season: season, dispute_month: dispute_month)
          round = FactoryBot.build(:v1_round, number: 11, season: season,
                                              dispute_month: dispute_month)
          error_message = 'Validation failed: Number Rodada já existente na temporada'
          expect { round.save! }.to raise_error(ActiveRecord::RecordInvalid, error_message)
        end
      end

      describe 'validates_more_than_two' do
        it 'allow even two rounds active per season' do
          FactoryBot.create(:v1_round, number: 20, finished: false, season: season,  dispute_month: dispute_month)
          FactoryBot.create(:v1_round, number: 21, finished: false, season: season,  dispute_month: dispute_month)
          expect(season.active_rounds.count).to eq(2)
        end
      end

      describe 'self.exist_round?' do
        it 'return true if it exists' do
          FactoryBot.create(:v1_round,
                            finished: false,
                            season: season,
                            dispute_month: dispute_month,
                            number: 13)
          expect(Round.exist_round?(season, 13)).to be true
        end
      end

      describe 'check_new_round' do
        it 'raise error if market status is invalid' do
          allow(Connection).to receive(:market_status).and_return(nil)
          expect(Round.check_new_round.message).to eq('Erro: mercado invalido / fechado')
        end

        it 'return error if round already exist' do
          allow(Round).to receive(:new_round).and_return(data)
          allow(Round).to receive(:exist_round?).and_return(true)
          expect(Round.check_new_round).to be_instance_of(FlowControl)
        end

        it 'return the newly created round' do
          round = FactoryBot.create(:v1_round, finished: false, season: season,
                                               dispute_month: dispute_month, number: 16)
          allow(Connection).to receive(:market_status).and_return(data)
          allow(Round).to receive(:new_round).and_return(round)
          expect(Round.check_new_round).to eq(round)
        end
      end

      describe 'new_round' do
        let(:market_status) { data }
        let(:round) do
          return FactoryBot.create(:v1_round, season: season, dispute_month: dispute_month,
                                              number: 16, finished: false)
        end

        before do
          allow(Round).to receive(:find_dispute_month).and_return(dispute_month)
        end

        it 'return newly created round  if allowed' do
          season.dispute_months.push(dispute_month)
          expect(Round.new_round(season, market_status).number).to eq(14)
        end

        it 'raise error if round is invalid' do
          season.dispute_months.push(dispute_month)
          Round.new_round(season, market_status)
          expect { Round.new_round(season, 19) }.to raise_error
        end
      end

      describe 'update_market_status' do
        let(:round) do
          return FactoryBot.create(:v1_round, season: season, number: 11,
                                              dispute_month: dispute_month)
        end
        let(:round_control) { RoundControl.create(round: round, market_closed: false) }

        it 'returns true' do
          round.round_control = round_control
          expect(Round.update_market_status([round])).to eq(true)
        end

        it 'changes round control market closed' do
          round.round_control = round_control
          Round.update_market_status([round])
          expect(round_control.market_closed).to be true
        end
      end

      describe 'rounds_allowed_to_generate_battles' do
        let(:round) do
          return FactoryBot.create(:v1_round, season: season, number: 14,
                                              dispute_month: dispute_month,
                                              market_close: DateTime.new(2019, 1, 1, 0, 0, 0))
        end
        let(:round_control) { RoundControl.create(round: round, market_closed: false) }
        let(:data_close) do
          return {
            'fechamento' => {
              'ano' => 2019, 'mes' => 1,
              'dia' => 1, 'hora' => 14, 'minuto' => 0
            },
            'rodada_atual' => 14,
            'status_mercado' => 2,
            'market_closed' => true
          }
        end

        it 'return array of allowed rounds' do
          round.round_control = round_control
          allow(Connection).to receive(:market_status).and_return(data_close)
          travel_to(round.market_close + 1.day)
          expect(Round.rounds_allowed_to_generate_battles.first).to eq(round)
          travel_back
        end

        it 'return empty if no rounds meet the conditions' do
          market_status = data
          market_status['status_mercado'] = 4
          allow(Connection).to receive(:market_status).and_return(market_status)
          expect(Round.rounds_allowed_to_generate_battles).to eq([])
        end
      end

      describe 'close_market' do
        before do
          allow(Round).to receive(:find_dispute_month).and_return(dispute_month)
        end

        it 'return true if success' do
          expect(Round.close_market).to be true
        end

        it 'returns flow control if it fails' do
          allow(Round).to receive(:rounds_allowed_to_generate_battles).and_return(nil)
          expect(Round.close_market).to be_instance_of(FlowControl)
        end
      end

      describe 'finish_round' do
        let(:round_to_finish) do
          return FactoryBot.create(:v1_round, season: season, number: 11,
                                              dispute_month: dispute_month,
                                              finished: false)
        end

        let(:round_control) do
          return RoundControl.create(market_closed: true, round: round_to_finish,
                                     battles_generated: true,
                                     scores_created: true)
        end

        before do
          round_to_finish.round_control = round_control
          allow(Connection).to receive(:market_status).and_return('market_open' => true)
        end

        it 'update round to finished' do
          allow(Round).to receive(:avaliable_to_be_finished).and_return([round_to_finish])
          Round.finish_round
          expect(round_to_finish.finished).to be true
        end

        it 'return true' do
          expect(Round.finish_round).to be true
        end
      end

      describe 'avaliable_for_score_generation' do
        let(:round_to_generate_scores) do
          return FactoryBot.create(:v1_round, season: season, number: 11,
                                              dispute_month: dispute_month,
                                              finished: false)
        end

        let(:round_control) do
          return RoundControl.create(market_closed: true, round: round_to_generate_scores,
                                     creating_scores: false, scores_created: false)
        end

        before do
          round_to_generate_scores.round_control = round_control
        end

        it 'returns all avaliable rounds' do
          expect(Round.avaliable_for_score_generation).to eq([round_to_generate_scores])
        end
      end

      describe 'avaliable_for_battles' do
        let(:round_to_generate_battles) do
          return FactoryBot.create(:v1_round, season: season, number: 11,
                                              dispute_month: dispute_month,
                                              finished: false)
        end

        let(:round_control) do
          return RoundControl.create(market_closed: true, round: round_to_generate_battles,
                                     generating_battles: false, battles_generated: false)
        end

        before do
          round_to_generate_battles.round_control = round_control
        end

        it 'returns all avaliable rounds' do
          expect(Round.avaliable_for_battles).to eq([round_to_generate_battles])
        end
      end

      describe 'rounds_with_scores_to_update' do
        let(:round_with_scores) do
          return FactoryBot.create(:v1_round, season: season, number: 11,
                                              dispute_month: dispute_month,
                                              finished: true)
        end

        let(:round_control) do
          return RoundControl.create(round: round_with_scores,
                                     scores_created: true, scores_updated: false,
                                     updating_scores: false)
        end

        before do
          round_with_scores.round_control = round_control
        end

        it 'returns all avaliable rounds' do
          expect(Round.rounds_with_scores_to_update).to eq([round_with_scores])
        end
      end

      describe 'rounds_with_battles_to_update' do
        let(:round_to_update) do
          return FactoryBot.create(:v1_round, season: season, number: 11,
                                              dispute_month: dispute_month,
                                              finished: true)
        end

        let(:round_control) do
          return RoundControl.create(round: round_to_update,
                                     battles_generated: true, scores_updated: true,
                                     updating_battle_scores: false,
                                     battle_scores_updated: false)
        end

        before do
          round_to_update.round_control = round_control
        end

        it 'returns all avaliable rounds' do
          expect(Round.rounds_with_battles_to_update).to eq([round_to_update])
        end
      end

      describe 'find_dispute_month' do
        it 'return a dispute month if it finds any' do
          allow(season).to receive(:dispute_months).and_return([dispute_month]) # 10 e 20
          expect(Round.find_dispute_month(season, 11)).to be_instance_of(DisputeMonth)
        end

        it 'returns nil otherwise' do
          allow(season).to receive(:dispute_months).and_return([])
          expect(Round.find_dispute_month(season, 120)).to be_nil
        end
      end

      describe 'ghost_scores' do
        let(:round) do
          return FactoryBot.create(:v1_round, season: season, number: 11,
                                              dispute_month: dispute_month,
                                              finished: true)
        end

        let(:scores) do
          return [
            Score.new(final_score: 6, round: round),
            Score.new(final_score: 2, round: round)
          ]
        end

        it 'return the average excluding ghost buster score' do
          allow(round).to receive(:ghost_buster_score).and_return(2)
          expect(round.ghost_score(scores, false)).to eq(6)
        end
      end

      describe 'ghost_buster_score' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:battle) { Battle.new(first_id: team.id, second_id: nil) }
        let(:score) { Score.create(round: round, team: team, final_score: 8) }
        let(:round) do
          return FactoryBot.create(:v1_round, season: season, number: 11,
                                              dispute_month: dispute_month,
                                              finished: true)
        end

        before do
          round.scores << score
          allow(round).to receive(:find_ghost_battle).and_return(battle)
        end

        it 'returns the score if everthing goes right' do
          expect(round.ghost_buster_score('final_score', round.scores)).to eq(8)
        end
      end

      describe 'team_score' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:battle) { Battle.new(first_id: team.id, second_id: nil) }
        let(:score) { Score.create(round: round, team: team, final_score: 8) }
        let(:round) do
          return FactoryBot.create(:v1_round, season: season, number: 11,
                                              dispute_month: dispute_month,
                                              finished: true)
        end

        before do
          round.scores << score
          allow(round).to receive(:ghost_score).and_return(5)
        end

        it 'returns ghost score if team_id is nil' do
          expect(round.team_score(nil, round.scores)).to be(5)
        end

        it 'returns the final score of the team' do
          expect(round.team_score(team.id, round.scores)).to eq(8.0)
        end
      end

      describe 'find ghost battle' do
        let(:team) { FactoryBot.create(:v1_team) }
        let(:battle) { Battle.new(first_id: team.id, second_id: nil) }
        let(:round) do
          return FactoryBot.create(:v1_round, season: season, number: 11,
                                              dispute_month: dispute_month,
                                              finished: true)
        end

        it 'returns nil if no battle is find' do
          expect(round.find_ghost_battle).to be_nil
        end

        it 'returns the battle' do
          round.battles << battle
          expect(round.find_ghost_battle).to eq(battle)
        end
      end
    end
  end
end
