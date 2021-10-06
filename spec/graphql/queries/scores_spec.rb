require 'rails_helper'

RSpec.describe 'QueryType', type: :request do

  before do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  describe 'current_rules' do
    let(:season) { FactoryBot.create(:season) }
    let(:dispute) { FactoryBot.create(:dispute_month, season: season) }
    let(:team) { FactoryBot.create(:team) }
    let(:scores_query) do
      <<~GQL
        query{
          scores(disputeId: $dispute.id){
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

    let(:expectation) {

    }
    
    before do
      season.rounds.first(4).each do |round|
        round.update(dispute_month_id: dispute.id)
      end
    end

    it 'should return the scores' do
      post '/graphql', params: { query: scores_query }
      data = JSON.parse(response.body)['data']['scores']
      expect(data).to eq('to do')
    end
  end
end

