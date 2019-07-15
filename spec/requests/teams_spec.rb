require 'rails_helper'

module Api
  module V1
    RSpec.describe 'Team Requests', type: :request do
      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean
      end

      let(:team) { FactoryBot.create(:v1_team) }
      let(:user) do
        return User.create(email: 'test@gmail.com',
                           password: '123456',
                           password_confirmation: '123456')
      end

      describe 'POST activation' do
        it 'returns 401 if not authenticated' do
          post '/api/v1/teams/activation',
               params: { team: { id: team.id, active: false } }
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns 200 on activation' do
          post '/api/v1/teams/activation',
               params: { team: { id: team.id, active: false } },
               headers: auth_headers(user)
          expect(response).to have_http_status(:success)
        end

        it 'returns 422 if it fails' do
          post '/api/v1/teams/activation',
               params: { team: { active: false, id: nil } },
               headers: auth_headers(user)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
