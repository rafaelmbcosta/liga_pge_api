require 'rails_helper'

RSpec.describe 'save rules mutation', type: :request do

  before do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  describe 'save_rules' do
    let(:text) { '<h2> Ja vai tarde </h2>' }

    it 'should not permit unlogged users' do
      result =  CartolaPgeApiSchema.execute(save_rules_mutation, variables: { text: text })
      expect(result["errors"].first["message"]).to eq("You don't have PERMISSION to access that content")
    end
  end
end

def save_rules_mutation
  <<~GRAPHQL
    mutation($text: String!) {
      saveRules(text: $text) {
        id
        text
      }
    }
  GRAPHQL
end
