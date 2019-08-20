require 'rails_helper'

module Api
  module V1
    RSpec.describe 'Authenticated Requests', type: :request do
      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean
      end

      let(:user) do
        return User.create(email: 'test@gmail.com',
                           password: '123456',
                           password_confirmation: '123456')
      end

      describe 'routines request' do
        before do
          allow(Round).to receive(:closed_market_routines).and_return([])
          allow(Round).to receive(:round_finished_routines).and_return([])
        end

        it 'returns 200 on closed_market_routines' do
          get '/api/v1/closed_market_routines',
              headers: auth_headers(user)
          expect(response).to have_http_status(:success)
        end

        it 'returns 200 on round_finished_routines' do
          get '/api/v1/round_finished_routines',
              headers: auth_headers(user)
          expect(response).to have_http_status(:success)
        end
      end

      describe 'Rerunning currencies' do
        it 'returns success on execution' do
          get '/api/v1/currencies/rerun/',
              headers: auth_headers(user)
          expect(response).to have_http_status(:success)
        end
      end

      describe 'POST activation' do
        let(:team) { FactoryBot.create(:v1_team) }
        
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

      describe 'flow control list' do
        it 'returns 200 on success' do
          get '/api/v1/flow_control',
              headers: auth_headers(user)
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
