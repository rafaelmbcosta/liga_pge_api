require 'rails_helper'

RSpec.describe 'save rules mutation', type: :request do

  before do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  describe 'save_rules' do
    let(:text) { '<h2> Ja vai tarde </h2>' }

    it 'should create a new rule' do
      result =  CartolaPgeApiSchema.execute(save_rules_mutation, variables: { text: text })
      expect(Rule.last.text).to eq(text)
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
