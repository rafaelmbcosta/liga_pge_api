require 'active_support/concern'

module Api::V1::Concerns::Team::Sync
  extend ActiveSupport::Concern

  included do
    def self.sync
      uri = URI("#{ENV['API_PROD']}/teams")
      api_teams =  Connection.connect(uri)
      create(api_teams)
    end
  end
end