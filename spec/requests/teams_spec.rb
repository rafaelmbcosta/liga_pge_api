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

      describe 'find_team' do
        let(:json) do
          [
            {
              'time_id': 13940706,
              'nome': 'Ferrimbahçe',
              'nome_cartola': 'Rafael Costa',
              'slug': 'ferrimbahce',
              'url_escudo_png': 'https://s2.glbimg.com/_PR4nkr2W4gsrtRk3lKHIUnVLeY=/https://s3.glbimg.com/v1/AUTH_58d78b787ec34892b5aaa0c7a146155f/cartola_svg_112/escudo/e6/09/39/001d366c29-9e34-4201-958b-34aa246edfe620180414140939',
              'url_escudo_svg': 'https://s3.glbimg.com/v1/AUTH_58d78b787ec34892b5aaa0c7a146155f/cartola_svg_112/escudo/e6/09/39/001d366c29-9e34-4201-958b-34aa246edfe620180414140939',
              'assinante': false
            }
          ]
        end

        before do
          allow(Connection).to receive(:team_data).and_return(json)
        end

        it 'returns official api json' do
          get '/api/v1/teams/find_team?[search]q=ferrao',
              headers: auth_headers(user)
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
