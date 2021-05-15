require 'rails_helper'

RSpec.describe 'QueryType', type: :request do

  before do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  describe 'current_rules' do
    let(:text) { '<h1> Seja bem vindo! </h1>' }
    let(:rule) { FactoryBot.build(:rule, text: text) }
    let(:current_rule_query) {
      <<~GQL
        query {
          currentRules {
            text
          }
        }
      GQL
    }

    before do
      allow(Rule).to receive(:last).and_return(rule)
    end

    it 'should match the last text' do
      post '/graphql', params: { query: current_rule_query }
      data = JSON.parse(response.body)['data']['currentRules']
      expect(data['text']).to eq(text)
    end
  end
end

