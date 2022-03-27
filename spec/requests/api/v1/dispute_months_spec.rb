require 'swagger_helper'
require_relative '../../response_examples/dispute_month_example'

RSpec.describe 'api/v1/dispute_months', type: :request do
  path '/api/v1/dispute_months' do

    get 'dispute_months' do
      tags 'Scores/DisputeMonth'
      produces 'application/json'

      response 200, 'Successful' do
        schema type: :object, properties: {
          data: { type: :array, items: { '$ref' => '#/components/schemas/DisputeMonth' } }
        }
        run_test! do
          expect(true).to be false
        end
      end
    end
  end
end
