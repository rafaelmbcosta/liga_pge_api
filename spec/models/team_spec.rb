require 'rails_helper'

RSpec.describe Team, type: :model do
  it_behaves_like 'battle_teams'
end
#       let(:team) { Team.create(name: 'team-1', active: true) }

#       describe 'activation' do
#         let(:team_params) { { id: team.id, active: false } }
#         let(:success) { { success: true } }
#         let(:failure) { { success: false, message: 'Erro ao atualizar time' } }

#         it 'returns { success: true } in case of success' do
#           expect(Team.activation(team_params)).to eq(success)
#         end

#         it "returns { success: false, message: '...'' if it fails" do
#           team_params[:id] = nil
#           expect(Team.activation(team_params)).to eq(failure)
#         end
#       end

#

#
#     end
#   end
# end