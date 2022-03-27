# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'

  string_type = { type: :string }
  number_type = { type: :integer }
  float_type = { type: :number, multipleOf: 0.1 }

  shared_definitions = {
    score: {
      round: number_type,
      points: float_type
    },
    player: {
      type: :object,
      properties: {
        name: string_type,
        team: string_type,
        team_symbol: string_type,
        points: float_type,
        details: {
          type: :array,
          items: {
            type: :object,
            properties: {
              round: number_type,
              points: float_type
            }
          }
        }
      }
    }
  }

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      definitions: shared_definitions,
      paths: {},
      components: {
        schemas: {
          DisputeMonth: {
            type: :object,
            properties: {
              id: number_type,
              name: string_type,
              players: {
                type: :array,
                items: { '$ref' => '#/definitions/player' }
              }
            }
          }
        }
      },
      servers: [
        {
          url: 'https://localhost:3001',
          variables: {
            defaultHost: {
              default: 'http://localhost:3001'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
