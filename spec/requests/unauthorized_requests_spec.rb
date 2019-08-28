require 'rails_helper'

module Api
  module V1
    RSpec.describe 'Unauthorized requests', type: :request do
      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean
      end

      describe 'POST activation' do
        let(:team) { FactoryBot.create(:v1_team) }

        it 'returns 401 if not authenticated' do
          post '/api/v1/teams/activation',
               params: { team: { id: team.id, active: false } }
          expect(response).to have_http_status(:unauthorized)
        end
      end

      describe 'GET currencies' do
        it 'return success' do
          get '/api/v1/currencies'
          expect(response).to have_http_status(:success)
        end
      end

      describe 'GET teams' do
        it 'response is success' do
          get '/api/v1/teams'
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
