require 'rails_helper'

RSpec.describe 'Teams mutation', type: :request do

  before do
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

#   describe 'createTeamById' do
#     let(:team_id) { 2835272 }

#     it 'should create a new team' do
#       result =  CartolaPgeApiSchema.execute(create_team_mutation, variables: { team_id: team_id })
#       expect(Rule.last.text).to eq(text)
#     end
#   end
# end

# def create_team_mutation
#   {
#     "data": {
#       "createTeamById": {
#         "active": true,
#         "id": "19",
#         "idTag": 2835272,
#         "name": null,
#         "playerName": null,
#         "slug": null,
#         "urlEscudoPng": null
#       }
#     }
#   }
# end
end
