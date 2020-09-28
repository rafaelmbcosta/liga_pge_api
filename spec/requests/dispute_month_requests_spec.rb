require 'rails_helper'

module Api
  module V1
    RSpec.describe 'Dispute Month Requests', type: :request do
      before do
        DatabaseCleaner.start
        DatabaseCleaner.clean
      end

      let(:user) do
        return User.create(email: 'test@gmail.com',
                           password: '123456',
                           password_confirmation: '123456')
      end

      describe 'GET seasons season_dispute_months' do
        let(:season) { FactoryBot.create(:v1_season) }
        let(:april) do
          FactoryBot.create(:v1_dispute_month, name: 'Abril/Maio', season: season,
                                               dispute_rounds: (1..6).to_a)
        end
        let(:june) do
          FactoryBot.create(:v1_dispute_month, name: 'Junho/Julho', season: season,
                                               dispute_rounds: (7..12).to_a)
        end
        let(:august) do
          FactoryBot.create(:v1_dispute_month, name: 'Agosto', season: season,
                                               dispute_rounds: (13..16).to_a)
        end
        let(:september) do
          FactoryBot.create(:v1_dispute_month, name: 'Setembro', season: season,
                                               dispute_rounds: (17..22).to_a)
        end
        let(:october) do
          FactoryBot.create(:v1_dispute_month, name: 'Outubro', season: season,
                                               dispute_rounds: (23..29).to_a)
        end
        let(:november) do
          FactoryBot.create(:v1_dispute_month, name: 'Novembro/Dezembro', season: season,
                                               dispute_rounds: (30..38).to_a)
        end
        let(:expectation) do
          [
            {
              name: 'Abril/Maio',
              started: true,
              finished: true,
              rounds: [
                {
                  number: 1,
                  golden: false
                },
                {
                  number: 2,
                  golden: false
                },
                {
                  number: 3,
                  golden: true
                },
                {
                  number: 4,
                  golden: false
                },
                {
                  number: 5,
                  golden: false
                },
                {
                  number: 6,
                  golden: true
                }
              ]
            },
            {
              name: 'Junho/Julho',
              rounds: [
                {
                  number: 7,
                  golden: false
                },
                {
                  number: 8,
                  golden: false
                },
                {
                  number: 9,
                  golden: true
                },
                {
                  number: 10,
                  golden: false
                },
                {
                  number: 11,
                  golden: false
                },
                {
                  number: 12,
                  golden: true
                }
              ]
            },
            { name: 'Agosto', rounds: [] },
            { name: 'Setembro', rounds: [] },
            { name: 'Outubro', rounds: [] },
            { name: 'Novembro/Dezembro', rounds: [] }
          ]
        end
      end
    end
  end
end