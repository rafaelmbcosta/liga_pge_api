# require 'rails_helper'

# module Api
#   module V1
#     RSpec.describe 'Authenticated Requests', type: :request do
#       before do
#         DatabaseCleaner.start
#         DatabaseCleaner.clean
#       end

#       let(:user) do
#         return User.create(email: 'test@gmail.com',
#                            password: '123456',
#                            password_confirmation: '123456')
#       end

#       describe 'routines request' do
#         before do
#           allow(Round).to receive(:closed_market_routines).and_return([])
#           allow(Round).to receive(:round_finished_routines).and_return([])
#         end

#         it 'returns 200 on closed_market_routines' do
#           get '/api/v1/closed_market_routines',
#               headers: auth_headers(user)
#           expect(response).to have_http_status(:success)
#         end

#         it 'returns 200 on round_finished_routines' do
#           get '/api/v1/round_finished_routines',
#               headers: auth_headers(user)
#           expect(response).to have_http_status(:success)
#         end
#       end

#       describe 'Rerunning currencies' do
#         it 'returns success on execution' do
#           get '/api/v1/currencies/rerun/', headers: auth_headers(user)
#           expect(response).to have_http_status(:success)
#         end
#       end

#       describe 'POST activation' do
#         let(:team) { FactoryBot.create(:v1_team) }

#         it 'returns 200 on activation' do
#           post '/api/v1/teams/activation',
#                params: { team: { id: team.id, active: false } },
#                headers: auth_headers(user)
#           expect(response).to have_http_status(:success)
#         end

#         it 'returns 422 if it fails' do
#           post '/api/v1/teams/activation',
#                params: { team: { active: false, id: nil } },
#                headers: auth_headers(user)
#           expect(response).to have_http_status(:unprocessable_entity)
#         end
#       end

#       describe 'find_team' do
#         let(:json) do
#           [
#             {
#               'time_id': 13940706,
#               'nome': 'Ferrimbahçe',
#               'nome_cartola': 'Rafael Costa',
#               'slug': 'ferrimbahce',
#               'url_escudo_png': 'https://s2.glbimg.com/_PR4nkr2W4gsrtRk3lKHIUnVLeY=/https://s3.glbimg.com/v1/AUTH_58d78b787ec34892b5aaa0c7a146155f/cartola_svg_112/escudo/e6/09/39/001d366c29-9e34-4201-958b-34aa246edfe620180414140939',
#               'url_escudo_svg': 'https://s3.glbimg.com/v1/AUTH_58d78b787ec34892b5aaa0c7a146155f/cartola_svg_112/escudo/e6/09/39/001d366c29-9e34-4201-958b-34aa246edfe620180414140939',
#               'assinante': false
#             }
#           ]
#         end

#         before do
#           allow(Connection).to receive(:team_data).and_return(json)
#         end

#         it 'returns official api json' do
#           get '/api/v1/teams/find_team?[search]q=ferrao',
#               headers: auth_headers(user)
#           expect(response).to have_http_status(:success)
#         end
#       end

#       describe 'tasks' do
#         before do
#           allow(SeasonWorker).to receive(:perform).and_return(true)
#           allow(BattleWorker).to receive(:perform).and_return(true)
#           allow(ScoresWorker).to receive(:perform).and_return(true)
#           allow(CurrencyWorker).to receive(:perform).and_return(true)
#           allow(RoundWorker).to receive(:perform).and_return(true)
#           allow(TeamWorker).to receive(:perform).and_return(true)
#         end

#         it 'return success on closed_market_routines' do
#           get '/api/v1/closed_market_routines',
#               headers: auth_headers(user)
#           expect(response).to have_http_status(:success)
#         end

#         it 'return success on round_finished_routines' do
#           get '/api/v1/round_finished_routines',
#               headers: auth_headers(user)
#           expect(response).to have_http_status(:success)
#         end

#         it 'return success on general_tasks_routine' do
#           get '/api/v1/general_tasks_routines',
#               headers: auth_headers(user)
#           expect(response).to have_http_status(:success)
#         end
#       end

#       describe 'active_round_progress' do
#         let(:progress_expectation) do
#           [
#             {
#               attribute: :market_closed,
#               label: 'Mercado fechado',
#               round: false,
#               step: 1,
#               value: true
#             },
#             {
#               attribute: :battles_generated,
#               label: 'Batalhas criadas',
#               round: false,
#               step: 2,
#               value: true
#             },
#             {
#               attribute: :scores_created,
#               label: 'Placares criados',
#               round: false,
#               step: 3,
#               value: true
#             },
#             {
#               attribute: :finished,
#               label: 'Rodada finalizada',
#               round: true,
#               step: 4,
#               value: true
#             },
#             {
#               attribute: :scores_updated,
#               label: 'Placares atualizados',
#               round: false,
#               step: 5,
#               value: true
#             },
#             {
#               attribute: :battle_scores_updated,
#               label: 'Confrontos atualizados',
#               round: false,
#               step: 6,
#               value: true
#             },
#             {
#               attribute: :currencies_generated,
#               label: 'Cartoletas criadas',
#               round: false,
#               step: 7,
#               value: true
#             }
#           ]
#         end

#         before do
#           allow(Round).to receive(:progress_active).and_return(progress_expectation)
#         end

#         it 'returns an array of progresses' do
#           get '/api/v1/active_rounds_progress', headers: auth_headers(user)
#           expect(response).to have_http_status(:success)
#           expect(response.body).to eq({ progress: progress_expectation }.to_json)
#         end
#       end
#     end
#   end
# end
