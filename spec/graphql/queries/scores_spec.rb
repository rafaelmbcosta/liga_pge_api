require 'rails_helper'

RSpec.describe 'QueryType', type: :request do

  before do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  describe 'current_rules' do
    let(:season) { FactoryBot.create(:season) }
    let(:dispute) { FactoryBot.create(:dispute_month, season: season) }
    let(:team) { FactoryBot.create(:team, id_tag: '1234') }
    let(:scores_query) do
      <<~GQL
        query{
          scores(disputeId: #{dispute.id}){
            score
            team {
              name
            }
            scores {
              round {
                number
              }
              finalScore
            }
          }
        }
      GQL
    end

    let(:expectation) do
      [
        { 
          score: 100,
          scores: [
            { finalScore: 10.0, round: { number: 1 } },
            { finalScore: 20.0, round: { number: 2 } },
            { finalScore: 30.0, round: { number: 3 } },
            { finalScore: 40.0, round: { number: 4 } }
          ],
          team: { name: team.name } 
        }.deep_stringify_keys
      ]
    end
      
    before do
      season.rounds.first(4).each do |round|
        round.update(dispute_month_id: dispute.id)
        FactoryBot.create(:score, team: team, round: round, final_score: round.number * 10)
      end
    end

    it 'should return the scores' do
      post '/graphql', params: { query: scores_query }
      data = JSON.parse(response.body)['data']['scores']
      expect(data).to eq(expectation)
    end
  end
end

