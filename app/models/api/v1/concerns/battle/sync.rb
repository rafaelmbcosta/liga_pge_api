require 'active_support/concern'

module Api::V1::Concerns::Battle::Sync
  extend ActiveSupport::Concern

  included do
    def self.sync
      uri = URI("#{ENV['API_PROD']}/battles/details")
      battles = ::Api::V1::Connection.connect(uri)
      create(battles)
    end
  end
end