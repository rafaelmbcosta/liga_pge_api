# require 'rails_helper'

# module Api
#   module V1
#     RSpec.describe Round, type: :model do
#       let(:market_status) do
#         return {
#           'rodada_atual' => 1, 'status_mercado' => 2,
#           'game_over' => false, 'temporada' => 2019
#         }
#       end

#       describe 'self.current_round' do
#         it 'returns the api round number' do
#           allow(Connection).to receive(:market_status).and_return(market_status)
#           expect(Connection.current_round).to eq(1)
#         end
#       end

#       describe 'market status' do
#         let(:open) { { 'status_mercado' => 1 } }

#         let(:closed) { { 'status_mercado' => 2 } }

#         it 'returns true if status = 1' do
#           expect(Connection.market_open?(open)).to eq(true)
#         end

#         it 'returns true if status = 2' do
#           expect(Connection.market_closed?(closed)).to eq(true)
#         end
#       end

#       describe 'close_date' do
#         let(:market_status) do
#           {
#             'fechamento' => {
#               'ano' => 2019,
#               'mes' => 12,
#               'dia' => 25,
#               'hora' => 10,
#               'minuto' => 15
#             }
#           }
#         end

#         it 'returns a date with parameters' do
#           expect(Connection.close_date(market_status)).to eq(DateTime.new(2019, 12, 25, 10, 15))
#         end
#       end

#       describe 'connect' do
#         let(:json) { { name: 'test' }.to_json }

#         before do
#           allow(Net::HTTP).to receive(:get).and_return(json)
#         end

#         it 'return one string with the result' do
#           expect(Connection.connect(json)).to eq('name' => 'test')
#         end
#       end

#       describe 'market_status' do
#         let(:expectation) do
#           {
#             'market_open' => true,
#             'market_closed' => false,
#             'close_date' => DateTime.new(2019, 12, 25, 10, 15)
#           }
#         end

#         before do
#           allow(Connection).to receive(:connect).and_return({})
#           allow(Connection).to receive(:market_open?).and_return(true)
#           allow(Connection).to receive(:market_closed?).and_return(false)
#           allow(Connection).to receive(:close_date).and_return(DateTime.new(2019, 12, 25, 10, 15))
#         end

#         it 'adds attributes to the market' do
#           expect(Connection.market_status).to eq(expectation)
#         end
#       end

#       describe 'some connections' do
#         before do
#           allow(Connection).to receive(:connect).and_return({})
#         end

#         it 'team_score' do
#           expect(Connection.team_score('2')).to eq({})
#         end

#         it 'team_data' do
#           expect(Connection.team_data('ferrao')).to eq({})
#         end

#         it 'athletes_scores' do
#           expect(Connection.athletes_scores).to eq({})
#         end
#       end
#     end
#   end
# end
