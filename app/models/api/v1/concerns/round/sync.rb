require 'active_support/concern'

module Api::V1::Concerns::Round::Sync
  extend ActiveSupport::Concern

  included do
    def self.sync
      uri = URI("#{ENV['API_PROD']}/rounds/finished")
      rounds = ::Api::V1::Connection.connect(uri)
      create(rounds)
    end
  end
end
